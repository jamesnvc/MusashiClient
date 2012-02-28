//
//  Workout.m
//  MusashiClient
//
//  Created by James Cash on 27-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "Workout.h"


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

- (SEL)setterForTrack:(NSInteger)idx
{
    switch (idx) {
        case 1:
            return @selector(setTrack1Id);
        case 2:
            return @selector(setTrack2Id);
        case 3:
            return @selector(setTrack3Id:);
        case 4:
            return @selector(setTrack4Id);
        case 5:
            return @selector(setTrack5Id);
        case 6:
            return @selector(setTrack6Id);
        case 7:
            return @selector(setTrack7Id);
        case 8:
            return @selector(setTrack8Id);
        case 9:
            return @selector(setTrack9Id);
        case 10:
            return @selector(setTrack10Id);
        case 11:
            return @selector(setTrack11Id);
        case 12:
            return @selector(setTrack12Id);
        default:
            return @selector(setTrack1Id);
    }
}

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

- (void)setTracks:(NSArray *)tracks
{
    assert([tracks count] == 12);
    for (int i = 1; i <= 12; i++) {
        [self performSelector:[self setterForTrack:i] 
                   withObject:[tracks objectAtIndex:i]];
    }
}

- (void)setTrack:(FullTrack *)track forSequence:(NSInteger)idx
{
    [self performSelector:[self setterForTrack:idx] withObject:track];
}
@end
