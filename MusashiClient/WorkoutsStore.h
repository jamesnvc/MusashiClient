//
//  WorkoutsStore.h
//  MusashiClient
//
//  Created by James Cash on 26-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface WorkoutsStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}
+ (WorkoutsStore *)defaultStore;

- (BOOL)saveChanges;
- (Workout *)createWorkoutNamed:(NSString *)name; 
- (NSArray *)allWorkouts;
- (void)deleteWorkout:(Workout *)workout;
@end
