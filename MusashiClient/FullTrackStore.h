//
//  FullTrackStore.h
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^TrackStoreCallback)(NSNumber *);

@interface FullTrackStore : NSObject
{
    NSMutableArray *allTracks;
    NSMutableData *recievedData;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    NSURLConnection *connection;
    TrackStoreCallback waitingCallback;
}
+ (FullTrackStore *)defaultStore;
- (BOOL)isLocalTrack:(NSNumber *)trackId;
- (void)fetchTrack:(NSNumber *)trackId;
- (void)fetchTrack:(NSNumber *)trackId
      withCallback:(TrackStoreCallback)callback;
- (void)fetchTracks:(NSArray *)trackList;
- (void)fetchTracks:(NSArray *)trackList 
       withCallback:(TrackStoreCallback)callback;
@end
