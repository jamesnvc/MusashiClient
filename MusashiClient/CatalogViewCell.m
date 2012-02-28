//
//  CatalogViewCell.m
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "CatalogViewCell.h"
#import "CatalogTrack.h"
#import "CatalogViewController.h"
#import "FullTrackStore.h"

@implementation CatalogViewCell
@synthesize enqueued, containingController, deletePending;

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        enqueued = NO;
        trackDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:trackDescLabel];
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:selectBtn];
        [selectBtn addTarget:self
                      action:@selector(toggleStatus:) 
            forControlEvents:UIControlEventTouchUpInside];
        spinner = [[UIActivityIndicatorView alloc] 
                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.hidesWhenStopped = YES;
        spinner.color = [UIColor blackColor];
        spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        spinner.center = CGPointMake(self.frame.size.width - 20.0,
                                     self.frame.size.height - 20.0);
        downloadIcon = [UIImage imageNamed:@"download.png"];
        queuedIcon = [UIImage imageNamed:@"inbox.png"];
        haveIcon = [UIImage imageNamed:@"house.png"];
        deleteIcon = [UIImage imageNamed:@"delete.png"];
        isLocal = NO;
        deletePending = NO;
    }
    return self;
}

- (void)toggleStatus:(id)sender
{
    if (isLocal) {
        [selectBtn setImage:deleteIcon forState:UIControlStateNormal];
        deletePending = YES;
        track.deletePending = YES;
    } else {
        enqueued = !enqueued;
        track.enqueued = enqueued;
        if (enqueued) {
            [selectBtn setImage:queuedIcon
                       forState:UIControlStateNormal];
        } else {
            [selectBtn setImage:downloadIcon
                       forState:UIControlStateNormal];
        }
    }
    [self setNeedsDisplay];
    [containingController displayExecuteDialog];
}

- (void)setTrack:(CatalogTrack *)trk
{
    track = trk;
    track.cell = self;
    track.enqueued = track.deletePending = NO;
}

- (void)startDownloading
{
    [selectBtn removeFromSuperview];
    [self addSubview:spinner];
    [spinner startAnimating];
}

- (void)downloadFinished
{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    [self addSubview:selectBtn];
    [selectBtn setImage:haveIcon forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    float h = bounds.size.height;
    float w = bounds.size.width;    
    float inset = 40.0;
    
    CGRect labelFrame = CGRectMake(inset, inset, 
                                  w - (40.0 + 2.0 * inset), h - inset * 2.0);
    [trackDescLabel setFrame:labelFrame];
    [trackDescLabel setText:[NSString
                             stringWithFormat:@"R%@ T%@",
                             [track.information objectForKey:@"release"],
                             [track.information objectForKey:@"sequence"]]];
    
    CGRect btnFrame = CGRectMake(w - (40.0 + inset), inset, 
                                 40.0 + 2.0 * inset, h - inset * 2.0);
    [selectBtn setFrame:btnFrame];

    enqueued = NO;
    isLocal = [[FullTrackStore defaultStore] 
               isLocalTrack:[track.information objectForKey:@"id"]];
    if (!isLocal) {
        [selectBtn setImage:downloadIcon
                   forState:UIControlStateNormal];
    } else {
        [selectBtn setImage:haveIcon
                   forState:UIControlStateNormal];
    }
}

@end
