//
//  FullTrackDetailViewController.h
//  MusashiClient
//
//  Created by James Cash on 15-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FullTrack;

@interface FullTrackDetailViewController : UIViewController 
    <UITableViewDataSource>
{
    UIWebView *pdfView;
}
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackDurationLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;
@property (weak, nonatomic) IBOutlet UITableView *blocksTable;
@property (nonatomic, strong) FullTrack *track;
- (IBAction)setPdfDisplay:(id)sender;
@end
