//
//  FullTrack.m
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "FullTrack.h"
#import "Move.h"


@implementation FullTrack

@dynamic releaseNumber;
@dynamic sequenceNumber;
@dynamic song;
@dynamic kind;
@dynamic length_minutes;
@dynamic length_seconds;
@dynamic pdfImage;
@dynamic blocks;
@dynamic trackId;

- (NSArray *)moveTypes
{
    NSMutableArray *moves = [[NSMutableArray alloc] init];
    for (NSManagedObject *blk in [self blocks]) {
        for (NSManagedObject *seq in [blk valueForKey:@"sequences"]) {
            for (Move *move in [seq valueForKey:@"moves"]) {
                [moves addObject:[move moveDescriptionNub]];
            }
        }
    }
    return moves;
}

- (NSDictionary *)moveFrequencies
{
    NSArray *moveDescs = [self moveTypes];
    NSMutableDictionary *freqs = [[NSMutableDictionary alloc] 
                                  initWithCapacity:[moveDescs count]];
    for (NSString *mv in moveDescs) {
        NSNumber *val = [freqs valueForKey:mv];
        if (val == nil) {
            val = [NSNumber numberWithInt:1];
        } else {
            val = [NSNumber numberWithInt:[val intValue] + 1];
        }
        [freqs setValue:val forKey:mv];
    }
    return freqs;
}

@end
