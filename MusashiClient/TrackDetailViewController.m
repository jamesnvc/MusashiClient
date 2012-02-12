//
//  TrackDetailViewController.m
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "TrackDetailViewController.h"
#import "CatalogTrack.h"
#import "FullTrackStore.h"

@implementation TrackDetailViewController
@synthesize releaseLabel, trackLabel, songLabel, durationLabel, typeLabel;
@synthesize downloadTrackBtn;
@synthesize track;

- (id)initForNewTrack:(BOOL)isNew
{
    self = [super initWithNibName:@"TrackDetailViewController"
                           bundle:nil];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewTrack:"
                                 userInfo:nil];
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *info = track.information;
    
    NSNumber *track_num = [info objectForKey:@"sequence"];
    NSNumber *release_num = [info objectForKey:@"release"];
    
    [releaseLabel setText:[NSString stringWithFormat:@"Release %@", release_num]];
    [trackLabel setText:[NSString stringWithFormat:@"Track %@", track_num]];
    [songLabel setText:[info objectForKey:@"song"]];
    [durationLabel setText:[NSString stringWithFormat:@"%@:%@",
                            [info objectForKey:@"length_minutes"],
                            [info objectForKey:@"length_seconds"]]];
    [typeLabel setText:[info objectForKey:@"kind"]];

    if ([[FullTrackStore defaultStore] isLocalTrack:[info objectForKey:@"id"]]) {
        [downloadTrackBtn setEnabled:NO];
    }
}

- (IBAction)downloadTrack:(id)sender 
{
    FullTrackStore *store = [FullTrackStore defaultStore];
    NSNumber *track_id = [track.information objectForKey:@"id"];
    if ([store isLocalTrack:track_id]) {
        return;
    }
    
    CGPoint btnLoc = downloadTrackBtn.center;
    UIActivityIndicatorView *loadingSpinner = 
    [[UIActivityIndicatorView alloc] 
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingSpinner.hidesWhenStopped = YES;
    loadingSpinner.color = [UIColor blackColor];
    loadingSpinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    loadingSpinner.center = btnLoc;
    [self.view addSubview:loadingSpinner];
    [loadingSpinner startAnimating];
    
    [downloadTrackBtn setHidden:YES];
    [store fetchTrack:track_id withCallback:^(NSNumber *tid) {
        [downloadTrackBtn setEnabled:NO];
        [downloadTrackBtn setHidden:NO];
        [loadingSpinner stopAnimating];
    }];
}

- (void)viewDidUnload {
    [self setReleaseLabel:nil];
    [self setTrackLabel:nil];
    [self setSongLabel:nil];
    [self setDurationLabel:nil];
    [self setTypeLabel:nil];
    [self setDownloadTrackBtn:nil];
    [super viewDidUnload];
}
@end
