//
//  Workout.h
//  MusashiClient
//
//  Created by James Cash on 27-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FullTrack;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * track1Id;
@property (nonatomic, retain) NSNumber * track2Id;
@property (nonatomic, retain) NSNumber * track3Id;
@property (nonatomic, retain) NSNumber * track4Id;
@property (nonatomic, retain) NSNumber * track5Id;
@property (nonatomic, retain) NSNumber * track6Id;
@property (nonatomic, retain) NSNumber * track7Id;
@property (nonatomic, retain) NSNumber * track8Id;
@property (nonatomic, retain) NSNumber * track9Id;
@property (nonatomic, retain) NSNumber * track10Id;
@property (nonatomic, retain) NSNumber * track11Id;
@property (nonatomic, retain) NSNumber * track12Id;
@property (nonatomic, strong) NSArray *tracks;
- (void)addTrack:(FullTrack *)track;
- (FullTrack *)trackForSequence:(NSInteger)sequence;
- (NSArray *)fullTracks;
@end
