//
//  CatalogViewCell.h
//  MusashiClient
//
//  Created by James Cash on 11-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatalogTrack;
@class CatalogViewController;

@interface CatalogViewCell : UITableViewCell
{
    UILabel *trackDescLabel;
    UIButton *selectBtn;
    CatalogTrack *track;
    BOOL isLocal;
    UIImage *downloadIcon;
    UIImage *queuedIcon;
    UIImage *haveIcon;
    UIImage *deleteIcon;
    UIActivityIndicatorView *spinner;
    __weak CatalogViewController *containingController;
}
@property (nonatomic) BOOL enqueued;
@property (nonatomic) BOOL deletePending;
@property (nonatomic, weak) CatalogViewController *containingController;
- (void)setTrack:(CatalogTrack *)trk;
- (void)toggleStatus:(id)sender;
- (void)downloadFinished;
- (void)startDownloading;
@end
