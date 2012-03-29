//
//  WorkoutEditViewController.h
//  MusashiClient
//
//  Created by James Cash on 17-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Workout;

@interface WorkoutEditViewController : UIViewController 
    <UIPickerViewDelegate, UIPickerViewDataSource, 
     UITextFieldDelegate>
{
    __weak UITextField *currentField;
    NSArray *tracks;
    UIActionSheet *actionSheet;
    NSMutableDictionary *selectedTracks;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic, retain) Workout *workout;
- (IBAction)showPickerView:(id)sender;
- (IBAction)saveWorkout:(id)sender;
- (IBAction)viewTrackDetail:(id)sender;
- (IBAction)analyzeWorkout:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@end
