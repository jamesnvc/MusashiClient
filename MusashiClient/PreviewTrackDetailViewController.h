//
//  PreviewTrackDetailViewController.h
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CatalogTrack;

@interface PreviewTrackDetailViewController : UIViewController
{

}
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadTrackBtn;
@property (nonatomic, strong) CatalogTrack *track;
- (IBAction)downloadTrack:(id)sender;
- (id)initForNewTrack:(BOOL)isNew;
@end
