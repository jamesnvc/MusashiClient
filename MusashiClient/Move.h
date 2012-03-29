//
//  Move.h
//  MusashiClient
//
//  Created by James Cash on 16-03-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Move : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * moveDescription;
@property (nonatomic, retain) NSNumber * sequenceNumber;
@property (nonatomic, retain) NSManagedObject *sequence;

- (NSString *)moveDescriptionNub;

@end
