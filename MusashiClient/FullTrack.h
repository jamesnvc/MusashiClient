//
//  FullTrack.h
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FullTrack : NSManagedObject

@property (nonatomic, retain) NSNumber * trackId;
@property (nonatomic, retain) NSNumber * releaseNumber;
@property (nonatomic, retain) NSNumber * sequenceNumber;
@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSNumber * length_minutes;
@property (nonatomic, retain) NSNumber * length_seconds;
@property (nonatomic, retain) NSData * pdfImage;
@property (nonatomic, retain) NSSet *blocks;
@end

@interface FullTrack (CoreDataGeneratedAccessors)

- (void)addBlocksObject:(NSManagedObject *)value;
- (void)removeBlocksObject:(NSManagedObject *)value;
- (void)addBlocks:(NSSet *)values;
- (void)removeBlocks:(NSSet *)values;
- (NSArray *)moveTypes;
- (NSDictionary *)moveFrequencies;

@end
