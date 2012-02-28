//
//  WorkoutsStore.m
//  MusashiClient
//
//  Created by James Cash on 26-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "WorkoutsStore.h"
#import "Workout.h"

@implementation WorkoutsStore

static WorkoutsStore *defaultStore = nil;

+ (WorkoutsStore *)defaultStore
{
    if (!defaultStore) {
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

#pragma mark - Lifecycle

- (id)init
{
    if (defaultStore) {
        return defaultStore;
    }
    self = [super init];
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] 
                                         initWithManagedObjectModel:model];
    
    NSString *path = pathInDocumentDirectory(@"store.data");
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeURL
                                 options:nil
                                   error:&error]) {
        [NSException raise:@"Open failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    // Created the managed object context
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    // Managed object context can managed undo, but we don't need it
    [context setUndoManager:nil];
    return self;
}

#pragma mark - Interacting with data store

- (Workout *)createWorkoutNamed:(NSString *)name
{
    Workout *wo = [NSEntityDescription 
                   insertNewObjectForEntityForName:@"Workout" 
                   inManagedObjectContext:context];
    
    wo.name = name;
    wo.createdAt = [NSDate date];
    NSError *err = nil;
    [context save:&err];
    return wo;
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    [context save:&err];
    return err == nil;
}

- (NSArray *)allWorkouts
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Workout"
                                   inManagedObjectContext:context];
    // Sort by date created?
    [req setEntity:entity];
    [req setSortDescriptors:[NSArray
                             arrayWithObject:[NSSortDescriptor
                                              sortDescriptorWithKey:@"createdAt"
                                              ascending:YES]]];
    NSError *err = nil;
    NSArray *results = [context executeFetchRequest:req error:&err];
    if (err) {
        NSLog(@"Error fetching tracks: %@", err);
    }
    return results;
}

- (void)deleteWorkout:(Workout *)workout
{
    [context deleteObject:workout];
}

@end
