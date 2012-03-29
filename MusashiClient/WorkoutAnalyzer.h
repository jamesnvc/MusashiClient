//
//  WorkoutAnalyzer.h
//  MusashiClient
//
//  Created by James Cash on 08-03-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Workout;

@interface WorkoutAnalyzer : NSObject
+ (WorkoutAnalyzer *)defaultAnalyzer;

- (NSDictionary *)analyze:(Workout *)workout;
- (NSString *)analyzeForOveruse:(Workout *)workout;
@end
