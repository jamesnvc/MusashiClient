//
//  WorkoutAnalysisViewController.h
//  MusashiClient
//
//  Created by James Cash on 21-03-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Workout;

@interface WorkoutAnalysisViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *progressStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressStatusSpinner;
@property (weak, nonatomic) IBOutlet UITextView  *outputTextView;
@property (strong, nonatomic) Workout *workout;

- (void)performAnalysis;
@end
