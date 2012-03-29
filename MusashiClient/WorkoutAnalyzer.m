//
//  WorkoutAnalyzer.m
//  MusashiClient
//
//  Created by James Cash on 08-03-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "WorkoutAnalyzer.h"
#import "FullTrack.h"
#import "Workout.h"

static WorkoutAnalyzer *defaultAnalyzer = nil;

@implementation WorkoutAnalyzer

#pragma mark - Lifecycle
+ (WorkoutAnalyzer *)defaultAnalyzer {
    if (!defaultAnalyzer) {
        defaultAnalyzer = [[super allocWithZone:NULL] init];
    }
    return defaultAnalyzer;    
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self defaultAnalyzer];
}

- (id)init {
    if (defaultAnalyzer) {
        return defaultAnalyzer;
    }
    self = [super init];
    
    return self;
}

#pragma mark - Analysis

- (NSString *)analyzeForOveruse:(Workout *)workout
{
    NSArray *tracks = [workout fullTracks];
    NSComparisonResult (^cmpBlk) (id obj1, id obj2) = ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSMutableArray *freqs = [[NSMutableArray alloc] init];
    for (FullTrack *track in tracks) {
        [freqs addObject:[track moveFrequencies]];
    }
    /* Compare adjacent frequency dictionaries to see if there is overlap in the 
     three most frequent moves */
    NSString *fmtStr = @"Tracks %d and %d may be too similiar!";
    NSMutableArray *warnings = [[NSMutableArray alloc] init];
    for (int i = 1; i < [freqs count]; i++) {
        NSDictionary *freq1, *freq2;
        freq1 = [freqs objectAtIndex:i - 1];
        freq2 = [freqs objectAtIndex:i];
        NSInteger minLen = MIN([freq1 count], [freq2 count]);
        if (minLen != 0) {
            NSIndexSet *topIdxs1 = [NSIndexSet 
                                   indexSetWithIndexesInRange:
                                   NSMakeRange(0, MIN(3, [freq1 count]))];
            NSIndexSet *topIdxs2 = [NSIndexSet 
                                    indexSetWithIndexesInRange:
                                    NSMakeRange(0, MIN(3, [freq2 count]))];
            NSSet *freq1Top = [NSSet 
                               setWithArray:[[freq1 keysSortedByValueUsingComparator:cmpBlk] 
                                             objectsAtIndexes:topIdxs1]];
            NSSet *freq2Top = [NSSet
                               setWithArray:[[freq2 keysSortedByValueUsingComparator:cmpBlk]
                                             objectsAtIndexes:topIdxs2]];
            if ([freq1Top intersectsSet:freq2Top]) {
                NSLog(@"Intersection between %@ and %@", freq1Top, freq2Top);
                [warnings addObject:[NSString stringWithFormat:fmtStr, i, i + 1]];
            }
        }
    }
    if ([warnings count] == 0) {
        return @"Looks good!";
    }
    return [warnings componentsJoinedByString:@"\n"];
}

- (NSDictionary *)analyze:(Workout *)workout
{
    NSDictionary *dict = [NSDictionary
                          dictionaryWithObject:[self analyzeForOveruse:workout]
                          forKey:@"Overuse"];
    return dict;
}
@end
