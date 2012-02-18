//
//  WorkoutViewController.m
//  MusashiClient
//
//  Created by James Cash on 17-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "WorkoutViewController.h"
#import "FullTrackStore.h"
#import "FullTrack.h"

@implementation WorkoutViewController
@synthesize track4Field;
@synthesize track5Field;
@synthesize track6Field;
@synthesize track3Field;
@synthesize track1Field;
@synthesize track2Field;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}

- (void)viewDidUnload
{
    [self setTrack1Field:nil];
    [self setTrack2Field:nil];
    [self setTrack3Field:nil];
    [self setTrack4Field:nil];
    [self setTrack5Field:nil];
    [self setTrack6Field:nil];
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
    tracks = [[FullTrackStore defaultStore] tracksAtSequences:trackNum];
    if (tracks == nil || [tracks count] == 0) {
        [sender setText:@"No available tracks"];
        [sender setTextColor:[UIColor grayColor]];
        [sender resignFirstResponder];
        return;
    }
    [sender resignFirstResponder];
    float w = self.view.frame.size.width;
    UIPickerView *picker = [[UIPickerView alloc] 
                            initWithFrame:CGRectMake(0, 240, w, 0)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
       inComponent:(NSInteger)component
{
    FullTrack *track = [tracks objectAtIndex:row];
    [currentField setText:[NSString stringWithFormat:@"Release %@",
                           [track valueForKey:@"releaseNumber"]]];
    [pickerView removeFromSuperview];
    tracks = nil;
    currentField = nil;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"Release %@",
            [[tracks objectAtIndex:row] valueForKey:@"releaseNumber"]];
}

@end
