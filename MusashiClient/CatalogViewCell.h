//
//  CatalogViewCell.h
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatalogTrack;

@interface CatalogViewCell : UITableViewCell
{
    UILabel *trackDescLabel;
    UIButton *selectBtn;
    CatalogTrack *track;
}
- (void)setTrack:(CatalogTrack *)trk;
@end
