//
//  FullTrackStore.m
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "FullTrackStore.h"
#import "FullTrack.h"

@interface FullTrackStore ()
- (NSString *)fullTracksArchivePath;
- (void)fetchPdfForTrack:(FullTrack *)track;
@end

@implementation FullTrackStore

static FullTrackStore *defaultStore = nil;
static FullTrack *dummy = nil;
static NSURL *apiBaseURL = nil;

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
    pdfDatums = [[NSMutableDictionary alloc] init];
    
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

#pragma mark - Interacting with the data store

- (BOOL)isLocalTrack:(NSNumber *)trackId
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FullTrack"
                                   inManagedObjectContext:context];
    [req setEntity:entity];
    NSPredicate *pred = [NSPredicate 
                         predicateWithFormat:@"trackId == %@", trackId];
    [req setPredicate:pred];
    NSError *err = nil;
    NSArray *res = [context executeFetchRequest:req error:&err];
    return (res && res.count);
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving %@",[err localizedDescription]);
    }
    return successful;
}

- (void)addSequencesWithData:(NSArray *)sequences 
                     toBlock:(NSManagedObject *)block;
{
    NSInteger i = 0;
    for (NSDictionary *sequence in sequences) {
        NSManagedObject *newSequence = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Sequence"
                                             inManagedObjectContext:context];
        NSDictionary *sameNamedValues = [sequence 
                                         dictionaryWithValuesForKeys:
                                         [NSArray arrayWithObjects:
                                          @"gear", @"reps", @"length", nil]];
        [newSequence setValuesForKeysWithDictionary:sameNamedValues];
        [newSequence setValue:[sequence objectForKey:@"description"]
                       forKey:@"sequenceDescription"];
        [newSequence setValue:[NSNumber numberWithInteger:i] 
                       forKey:@"sequenceNumber"];
        for (NSDictionary *move in [sequence objectForKey:@"moves"]) {
            NSManagedObject *newMove = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Move"
                                        inManagedObjectContext:context];
            [newMove setValue:[move objectForKey:@"description"]
                       forKey:@"moveDescription"];
            [newMove setValue:[move objectForKey:@"sequence"]
                       forKey:@"sequenceNumber"];
            [newMove setValue:[move objectForKey:@"count"] 
                       forKey:@"count"];
            [newMove setValue:newSequence forKey:@"sequence"];
        }
        [newSequence setValue:block forKey:@"block"];
        i += 1;
    }
}

- (void)addBlocksWithData:(NSArray *)blocks toTrack:(FullTrack *)track
{
    for (NSDictionary *block in blocks) {
        NSManagedObject *newBlock = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Block"
                                     inManagedObjectContext:context];
        [newBlock setValue:[block objectForKey:@"description"] 
                    forKey:@"blockDescription"];
        [newBlock setValue:[block objectForKey:@"sequence"]
                    forKey:@"sequenceNumber"];
        [self addSequencesWithData:[block objectForKey:@"exercises"]
                           toBlock:newBlock];
        [track addBlocksObject:newBlock];
    }
}

- (FullTrack *)createTrackFromData:(NSDictionary *)infoDict
{
    FullTrack *track = [NSEntityDescription 
                        insertNewObjectForEntityForName:@"FullTrack" 
                        inManagedObjectContext:context];
    NSDictionary *sameNamedValues = [infoDict
                                     dictionaryWithValuesForKeys:
                                     [NSArray arrayWithObjects:@"song",
                                      @"kind", @"length_minutes", 
                                      @"length_seconds", nil]];
    [track setValuesForKeysWithDictionary:sameNamedValues];
    track.releaseNumber = [infoDict objectForKey:@"release"];
    track.sequenceNumber = [infoDict objectForKey:@"sequence"];
    track.trackId = [infoDict objectForKey:@"id"];
    if ([infoDict valueForKey:@"has_pdf"]) {
        [self fetchPdfForTrack:track];
    }
    
    [self addBlocksWithData:[infoDict objectForKey:@"blocks"]
                    toTrack:track];
    
    [self saveChanges];
    return track;
}

- (FullTrack *)trackWithId:(NSNumber *)trackId
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FullTrack"
                                   inManagedObjectContext:context];
    [req setEntity:entity];
    NSPredicate *pred = [NSPredicate 
                         predicateWithFormat:@"trackId == %@", trackId];
    [req setPredicate:pred];
    NSError *err = nil;
    NSArray *res = [context executeFetchRequest:req error:&err];
    return [res lastObject];
}

- (NSArray *)tracksAtSequences:(NSNumber *)sequence
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FullTrack"
                                   inManagedObjectContext:context];
    [req setEntity:entity];
    NSPredicate *pred = [NSPredicate 
                         predicateWithFormat:@"sequenceNumber == %@", sequence];
    [req setPredicate:pred];
    NSError *err = nil;
    NSArray *results = [context executeFetchRequest:req error:&err];
    if (err) {
        NSLog(@"Error fetching tracks with sequence %@: %@", sequence, err);
    }
    return results;
}

- (NSArray *)allTracks
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FullTrack"
                                   inManagedObjectContext:context];
    [req setEntity:entity];
    NSError *err = nil;
    NSArray *results = [context executeFetchRequest:req error:&err];
    if (err) {
        NSLog(@"Error fetching tracks: %@", err);
    }
    return results;    
}

- (NSArray *)allTrackIds
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FullTrack"
                                   inManagedObjectContext:context];
    [req setEntity:entity];
    NSError *err = nil;
    NSArray *results = [context executeFetchRequest:req error:&err];
    if (err) {
        NSLog(@"Error fetching tracks: %@", err);
    }
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for (NSManagedObject *track in results) {
        [ids addObject:[track valueForKey:@"trackId"]];
    }
    return ids;
}

- (void)deleteTracksWithId:(NSArray *)trackIds
{
    for (NSNumber *trackId in trackIds) {
        [context deleteObject:[self trackWithId:trackId]];
    }
}

- (NSString *)fullTracksArchivePath
{
    return pathInDocumentDirectory(@"fulltracks.data");
}

#pragma mark - Fetching data from server

- (BOOL)connection:(NSURLConnection *)connection 
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection 
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Got authentication challenge: %@", challenge.protectionSpace.authenticationMethod);
    /* TODO: Factor this out into a setting */
    NSURLCredential *credential = [NSURLCredential 
                                   credentialWithUser:@"jamesnvc"
                                   password:@"H4_WWuTKy*7x1a"
                                   persistence:
                                     NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential
           forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    if (conn == connection) {
        [recievedData appendData:data];
    } else {
        [[[pdfDatums objectForKey:[NSNumber numberWithInteger:[conn hash]]] 
          objectAtIndex:0] appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    if (conn == connection) { /* Finished loading tracks */
        NSError *err;
        NSArray *recievedTracks = [NSJSONSerialization 
                                   JSONObjectWithData:recievedData
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
        [recievedTracks 
         enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             [self createTrackFromData:obj];
             waitingCallback([obj objectForKey:@"id"]);
         }];
        waitingCallback = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } else { /* Finished loading pdf data */
        NSArray *dataAndTrack = [pdfDatums objectForKey:
                                 [NSNumber numberWithInteger:[conn hash]]];
        NSData *pdfData = [dataAndTrack objectAtIndex:0];
        FullTrack *trk = [dataAndTrack objectAtIndex:1];
        trk.pdfImage = pdfData;
        [self saveChanges];
        [pdfDatums removeObjectForKey:conn];
    }
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    if (conn == connection) {
        connection = nil;
        recievedData = nil;
        waitingCallback = nil;
    } else {
        [pdfDatums removeObjectForKey:[NSNumber numberWithInteger:[conn hash]]];
    }
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

- (void)fetchPdfForTrack:(FullTrack *)track
{
    NSURL *pdfUrl = [NSURL 
                       URLWithString:[NSString 
                                      stringWithFormat:
                                      @"/s/pdfs/release%02@_track%02d.pdf",
                                      track.releaseNumber, 
                                      track.sequenceNumber.intValue]
                       relativeToURL:apiBaseURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:pdfUrl];
    NSURLConnection *pdfConn = [[NSURLConnection alloc] 
                                initWithRequest:req 
                                delegate:self 
                                startImmediately:NO];
    [pdfDatums setObject:[[NSArray alloc] 
                          initWithObjects:[[NSMutableData alloc] init], track,
                          nil]
                  forKey:[NSNumber numberWithInteger:[pdfConn hash]]];
    [pdfConn start];
}

- (void)fetchTrack:(NSNumber *)trackId
      withCallback:(TrackStoreCallback)callback
{
    NSArray *trackIds = [NSArray arrayWithObject:trackId];
    [self fetchTracks:trackIds withCallback:callback];
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

- (FullTrack *)dummyTrack
{
    if (dummy == nil) {
        dummy = [NSEntityDescription
                 insertNewObjectForEntityForName:@"FullTrack" 
                 inManagedObjectContext:context];
    }
    return dummy;
}

@end
