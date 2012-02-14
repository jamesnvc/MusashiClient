//
//  FullTrackStore.m
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "FullTrackStore.h"

static NSURL *apiBaseURL = nil;

@implementation FullTrackStore

static FullTrackStore *defaultStore = nil;

+ (FullTrackStore *)defaultStore
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
    
    apiBaseURL = [NSURL URLWithString:@"http://smooth-rain-7517.herokuapp.com"];
    
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = 
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
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

#pragma mark - Querying datastore

- (BOOL)isLocalTrack:(NSNumber *)trackId
{
    return NO;
}

- (void)fetchTrack:(NSNumber *)trackNumber
{
    [self fetchTrack:trackNumber withCallback:^(NSNumber *t){}];
}

- (void)fetchTrack:(NSNumber *)trackId
      withCallback:(TrackStoreCallback)callback
{
    NSArray *trackIds = [NSArray arrayWithObject:trackId];
    [self fetchTracks:trackIds withCallback:callback];
}

- (void)fetchTracks:(NSArray *)trackList
{
    [self fetchTracks:trackList withCallback:^(NSNumber *n){}];
}

- (void)fetchTracks:(NSArray *)trackList
       withCallback:(TrackStoreCallback)callback
{
    recievedData = [[NSMutableData alloc] init];
    waitingCallback = callback;
    NSURL *url = [NSURL URLWithString:@"/api/get/full"
                        relativeToURL:apiBaseURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"POST"];
    NSError *err;
    NSString *json_ids = [[NSString alloc] initWithData:[NSJSONSerialization 
                                                         dataWithJSONObject:trackList
                                                         options:0 
                                                        error:&err]
                                               encoding:NSUTF8StringEncoding];
                          
    if (err) {
        NSLog(@"Error converting array to JSON");
    }
    NSString *json_escaped = [json_ids
                              stringByAddingPercentEscapesUsingEncoding:
                              NSUTF8StringEncoding];
    NSString *params = [NSString stringWithFormat:@"tracks=%@", json_escaped];
    [req setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc]
                  initWithRequest:req delegate:self startImmediately:YES];
}

#pragma mark - Fetching data

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [recievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSError *err;
    NSArray *recievedTracks = [NSJSONSerialization JSONObjectWithData:recievedData
                                                              options:0 
                                                                error:&err];
    if (err) {
        NSString *errorString = [NSString 
                                 stringWithFormat:@"Error parsing JSON: %@",
                                 [err localizedDescription]];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:errorString 
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
    recievedData = nil;
    connection = nil;
    [recievedTracks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        waitingCallback([obj objectForKey:@"id"]);
    }];
    waitingCallback = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    connection = nil;
    recievedData = nil;
    waitingCallback = nil;
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [av show];
}

@end
