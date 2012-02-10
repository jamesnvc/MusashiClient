//
//  ExerciseCatalog.m
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "ExerciseCatalog.h"
#import "CatalogTrack.h"

@interface ExerciseCatalog ()
- (void)extractTracks:(NSArray *)trackData;
@end

@implementation ExerciseCatalog
@synthesize tracks;

- (id)initWithData:(NSArray *)trackData;
{
    self = [super init];
    if (self) {
        [self extractTracks:trackData];
    }
    return self;
}

- (void)extractTracks:(NSArray *)trackData
{
    tracks = [[NSMutableArray alloc] init];
    for (NSDictionary *props in trackData) {
        CatalogTrack *trk = [[CatalogTrack alloc] init];
        trk.information = props;
        [tracks addObject:trk];
    }
}

@end
