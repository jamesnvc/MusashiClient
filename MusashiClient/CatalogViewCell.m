//
//  CatalogViewCell.m
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "CatalogViewCell.h"
#import "CatalogTrack.h"

@implementation CatalogViewCell

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        trackDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:trackDescLabel];
        selectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:selectBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTrack:(CatalogTrack *)trk
{
    track = trk;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
