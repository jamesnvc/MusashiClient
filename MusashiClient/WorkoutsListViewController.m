//
//  WorkoutsListViewController.m
//  MusashiClient
//
//  Created by James Cash on 26-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "WorkoutsListViewController.h"
#import "WorkoutsStore.h"
#import "WorkoutEditViewController.h"
#import "Workout.h"

@implementation WorkoutsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
 
    self.navigationItem.rightBarButtonItem = 
       self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == 
            UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:
(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [[[WorkoutsStore defaultStore] 
             allWorkouts] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    NSArray *workouts = [[WorkoutsStore defaultStore] 
                         allWorkouts];
    NSInteger row = [indexPath indexAtPosition:1];
    if (row == [workouts count]) {
        cell.textLabel.text = @"Add Workout";
    } else {
        Workout *wo = [workouts objectAtIndex:row];
        [cell.textLabel setText:wo.name];
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView 
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath indexAtPosition:1] < 
      [self tableView:tableView numberOfRowsInSection:1];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutsStore *store = [WorkoutsStore defaultStore];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:
                      [NSArray arrayWithObject:indexPath] 
                         withRowAnimation:
         UITableViewRowAnimationFade];
        NSArray *workouts = [store allWorkouts];
        [store 
         deleteWorkout:[workouts objectAtIndex:
                        [indexPath indexAtPosition:1]]];

    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [store createWorkoutNamed:@"New Workout"];
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutsStore *store = [WorkoutsStore defaultStore];
    NSArray *workouts = [store allWorkouts];
    NSInteger row = [indexPath indexAtPosition:1];
    WorkoutEditViewController *dvc = 
      [[WorkoutEditViewController alloc] init];
    if (workouts == nil || row == [workouts count]) {
        dvc.workout = [store
                       createWorkoutNamed:@"New Workout"];
    } else {
        dvc.workout = [workouts objectAtIndex:row];
    }
    [self.navigationController pushViewController:dvc
                                         animated:YES];
}

@end
