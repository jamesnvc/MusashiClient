//
//  WorkoutAnalysisViewController.m
//  MusashiClient
//
//  Created by James Cash on 21-03-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "WorkoutAnalysisViewController.h"
#import "WorkoutAnalyzer.h"

@implementation WorkoutAnalysisViewController
@synthesize progressStatusLabel;
@synthesize progressStatusSpinner;
@synthesize outputTextView;
@synthesize workout;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performAnalysis];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setProgressStatusLabel:nil];
    [self setProgressStatusSpinner:nil];
    [self setOutputTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Analysis

- (void)performAnalysisTask
{
    NSLog(@"Performing analysis for %@", self.workout);
    if (self.workout != nil) {
        NSDictionary *analysises = [[WorkoutAnalyzer defaultAnalyzer]
                                    analyze:self.workout];
        NSLog(@"Analysis: %@", analysises);
        NSMutableArray *output = [[NSMutableArray alloc] 
                                  initWithCapacity:[analysises count] * 3];
        NSString *fmt = @"%@ analysis:";
        for (NSString *analysisType in analysises) {
            NSLog(@"Doing %@ analysis", analysisType);
            [output addObject:[NSString stringWithFormat:fmt, analysisType]];
            [output addObject:[analysises objectForKey:analysisType]];
            [output addObject:@"\n"];
        }
        NSLog(@"Analysis complete: %@", output);
        [self.outputTextView setText:[output componentsJoinedByString:@"\n"]];
        [self.progressStatusLabel setText:@"Analysis Complete!"];
        [self.progressStatusSpinner stopAnimating];
    } else {
        [self.progressStatusLabel setText:@"No workout to analyze!"];
        [self.progressStatusSpinner stopAnimating];
    }
    [self.view setNeedsDisplay];
}

- (void)performAnalysis
{
    NSInvocationOperation *op = [[NSInvocationOperation alloc] 
                                 initWithTarget:self
                                 selector:@selector(performAnalysisTask)
                                 object:nil];
    [op start];
}

@end
