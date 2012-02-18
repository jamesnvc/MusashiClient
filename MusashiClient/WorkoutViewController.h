//
//  WorkoutViewController.h
//  MusashiClient
//
//  Created by James Cash on 17-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutViewController : UIViewController 
    <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *tracks;
    __weak UITextField *currentField;
}
@property (weak, nonatomic) IBOutlet UITextField *track1Field;
@property (weak, nonatomic) IBOutlet UITextField *track2Field;
@property (weak, nonatomic) IBOutlet UITextField *track3Field;
@property (weak, nonatomic) IBOutlet UITextField *track4Field;
@property (weak, nonatomic) IBOutlet UITextField *track5Field;
@property (weak, nonatomic) IBOutlet UITextField *track6Field;
- (IBAction)showPickerView:(id)sender;
@end
