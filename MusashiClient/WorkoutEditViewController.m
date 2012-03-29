//
//  WorkoutEditViewController.m
//  MusashiClient
//
//  Created by James Cash on 17-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "WorkoutEditViewController.h"
#import "FullTrackStore.h"
#import "FullTrack.h"
#import "Workout.h"
#import "WorkoutsStore.h"
#import "FullTrackDetailViewController.h"
#import "WorkoutAnalysisViewController.h"

@interface WorkoutEditViewController ()
- (void)addDetailButtonForTrack:(FullTrack *)trk
                    atTextField:(UITextField *)textField;
@end

@implementation WorkoutEditViewController
@synthesize textFields;
@synthesize nameField;
@synthesize workout;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        actionSheet = nil;
        self.navigationItem.rightBarButtonItem = 
          [[UIBarButtonItem alloc] 
           initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
           target:self
           action:@selector(saveWorkout:)];
        selectedTracks = [NSMutableDictionary 
                          dictionaryWithCapacity:12];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

         
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [nameField setText:[workout name]];
    for (UITextField *textField in textFields) {
        FullTrack *trk = [workout 
                          trackForSequence:[textField tag]];
        if (trk) {
            [self addDetailButtonForTrack:trk atTextField:textField];
        }
    }
}

- (void)addDetailButtonForTrack:(FullTrack *)trk 
                    atTextField:(UITextField *)textField
{
    [textField 
     setText:[NSString 
              stringWithFormat:@"Release %@",
              trk.releaseNumber]];
    UIButton *btn = [UIButton
                     buttonWithType:UIButtonTypeDetailDisclosure];
    [btn setTag:[textField tag]];
    [btn addTarget:self
            action:@selector(viewTrackDetail:) 
  forControlEvents:UIControlEventTouchDown];
    CGRect textFieldFrame = textField.frame;
    CGFloat btnX = textFieldFrame.origin.x + textFieldFrame.size.width;
    CGFloat btnY = textFieldFrame.origin.y;
    CGPoint btnOrigin = CGPointMake(btnX, btnY);
    CGRect btnFrame = btn.frame;
    btnFrame.origin = btnOrigin;
    [btn setFrame:btnFrame];
    [self.view addSubview:btn];
}

- (IBAction)viewTrackDetail:(id)sender
{
    FullTrackDetailViewController *dvc = [[FullTrackDetailViewController alloc]
                                          init];
    dvc.track = [workout trackForSequence:[sender tag]];
    if (dvc.track == nil) {
        dvc.track = [selectedTracks 
                     objectForKey:[NSNumber numberWithInteger:[sender tag]]];
    }
    [self.navigationController pushViewController:dvc animated:YES];
}

- (IBAction)analyzeWorkout:(id)sender
{
    WorkoutAnalysisViewController *dvc = [[WorkoutAnalysisViewController alloc]
                                          init];
    /* TODO: Should we save changes before doing this? Could be unintuitive otherwise */
    dvc.workout = workout;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)viewDidUnload
{
    self.workout = nil;
    self.nameField = nil;
    [self setTextFields:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Picker stuff

- (IBAction)showPickerView:(id)sender
{
    NSNumber *trackNum = [sender valueForKey:@"tag"];
    currentField = sender;
    tracks = [[FullTrackStore defaultStore] 
              tracksAtSequences:trackNum];
    if (tracks == nil || [tracks count] == 0) {
        [sender setText:@"No available tracks"];
        [sender setTextColor:[UIColor grayColor]];
        [sender resignFirstResponder];
        return;
    }
    [sender resignFirstResponder];
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        UIToolbar *pickerToolbar = [[UIToolbar alloc] 
                                    initWithFrame:CGRectMake(0, 0, 320, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] initWithCapacity:2];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                      target:self action:nil];
        [barItems addObject:flexSpace];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self action:@selector(pickerDone:)];
        [barItems addObject:doneBtn];
        [pickerToolbar setItems:barItems animated:YES];
        [actionSheet addSubview:pickerToolbar];
        [actionSheet showInView:self.view];
        [actionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
    UIPickerView *picker = [[UIPickerView alloc] 
                            initWithFrame:CGRectMake(0, 44.0, 0, 0)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [actionSheet addSubview:picker];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component
{
    return [tracks count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (IBAction)pickerDone:(id)sender            
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
    tracks = nil;
    currentField = nil;
}

- (void)pickerView:(UIPickerView *)pickerView 
      didSelectRow:(NSInteger)row 
       inComponent:(NSInteger)component
{
    FullTrack *track = [tracks objectAtIndex:row];
    [selectedTracks setObject:track 
                       forKey:track.sequenceNumber];
    [currentField setText:[NSString stringWithFormat:@"Release %@",
                           track.releaseNumber]];
    [self addDetailButtonForTrack:track atTextField:currentField];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"Release %@",
            [[tracks objectAtIndex:row] 
             valueForKey:@"releaseNumber"]];
}

- (IBAction)saveWorkout:(id)sender
{
    for (FullTrack *track in [selectedTracks allValues]){
        NSLog(@"Setting track %@", track);
        [workout addTrack:track];
    }
    workout.name = nameField.text;
    [[WorkoutsStore defaultStore] saveChanges];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
@end
