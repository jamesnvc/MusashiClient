//
//  CatalogTrack.h
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CatalogViewCell;

@interface CatalogTrack : NSObject
{
    NSDictionary *information;
}
@property (nonatomic, strong) NSDictionary *information;
@property (nonatomic, weak) CatalogViewCell *cell;
@property (nonatomic) BOOL enqueued;
@end
