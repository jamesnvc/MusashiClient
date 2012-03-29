//
//  Workout.m
//  MusashiClient
//
//  Created by James Cash on 27-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "Workout.h"
#import "FullTrack.h"
#import "FullTrackStore.h"

@implementation Workout

@dynamic createdAt;
@dynamic name;
@dynamic track1Id;
@dynamic track2Id;
@dynamic track3Id;
@dynamic track4Id;
@dynamic track5Id;
@dynamic track6Id;
@dynamic track7Id;
@dynamic track8Id;
@dynamic track9Id;
@dynamic track10Id;
@dynamic track11Id;
@dynamic track12Id;

- (NSArray *)tracks
{
    return [NSArray arrayWithObjects:
            [self track1Id],
            [self track2Id],
            [self track3Id],
            [self track4Id],
            [self track5Id],
            [self track6Id],
            [self track7Id],
            [self track8Id],
            [self track9Id],
            [self track10Id],
            [self track11Id],
            [self track12Id],
            nil];
}

- (NSArray *)fullTracks
{
    FullTrackStore *store = [FullTrackStore defaultStore];
    NSArray *trackIds = [self tracks];
    NSMutableArray *fullTracks = [[NSMutableArray alloc] 
                                  initWithCapacity:[trackIds count]];
    for (NSNumber *trackId in trackIds) {
        FullTrack *trk;
        if ([trackId intValue] != 0) {
            trk = [store trackWithId:trackId];
        } else {
            NSLog(@"Nil track");
            trk = [store dummyTrack];
        }
        [fullTracks addObject:trk];
    }
    return fullTracks;
}

- (void)setTracks:(NSArray *)tracks
{
    for (FullTrack *track in tracks) {
        [self addTrack:track];
    }
}

- (void)addTrack:(FullTrack *)track
{
    switch ([track.sequenceNumber intValue]) {
        case 1:
            [self setTrack1Id:track.trackId];
            break;
        case 2:
            [self setTrack2Id:track.trackId];
            break;
        case 3:
            [self setTrack3Id:track.trackId];
            break;
        case 4:
            [self setTrack4Id:track.trackId];
            break;
        case 5:
            [self setTrack5Id:track.trackId];
            break;
        case 6:
            [self setTrack6Id:track.trackId];
            break;
        case 7:
            [self setTrack7Id:track.trackId];
            break;
        case 8:
            [self setTrack8Id:track.trackId];
            break;
        case 9:
            [self setTrack9Id:track.trackId];
            break;
        case 10:
            [self setTrack10Id:track.trackId];
            break;
        case 11:
            [self setTrack11Id:track.trackId];
            break;
        case 12:
            [self setTrack12Id:track.trackId];
            break;
        default:
            NSLog(@"Track with an unexpected sequence number: %@", track);
            break;
    }
}

- (FullTrack *)trackForSequence:(NSInteger)sequence
{
    NSNumber *trackId = nil;
    switch (sequence) {
        case 1:
            trackId = [self track1Id];
            break;
        case 2:
            trackId = [self track2Id];
            break;
        case 3:
            trackId = [self track3Id];
            break;
        case 4:
            trackId = [self track4Id];
            break;
        case 5:
            trackId = [self track5Id];
            break;
        case 6:
            trackId = [self track6Id];
            break;
        case 7:
            trackId = [self track7Id];
            break;
        case 8:
            trackId = [self track8Id];
            break;
        case 9:
            trackId = [self track9Id];
            break;
        case 10:
            trackId = [self track10Id];
            break;
        case 11:
            trackId = [self track11Id];
            break;
        case 12:
            trackId = [self track12Id];
            break;
        default:
            NSLog(@"Unexpected sequence number: %d", sequence);
            break;
    }
    if (trackId) {
        return [[FullTrackStore defaultStore] trackWithId:trackId];
    }
    return nil;
}
@end
