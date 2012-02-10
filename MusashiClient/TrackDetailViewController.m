//
//  TrackDetailViewController.m
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "TrackDetailViewController.h"
#import "CatalogTrack.h"

@implementation TrackDetailViewController
@synthesize releaseLabel, trackLabel, songLabel, durationLabel, typeLabel;
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
    
    [releaseLabel setText:[NSString stringWithFormat:@"Release %@",
                           [info objectForKey:@"release"]]];
    [trackLabel setText:[NSString stringWithFormat:@"Track %@",
                         [info objectForKey:@"sequence"]]];
    [songLabel setText:[info objectForKey:@"song"]];
    [durationLabel setText:[NSString stringWithFormat:@"%@:%@",
                            [info objectForKey:@"length_minutes"],
                            [info objectForKey:@"length_seconds"]]];
    [typeLabel setText:[info objectForKey:@"kind"]];
    
}

- (void)viewDidUnload {
    [self setReleaseLabel:nil];
    [self setTrackLabel:nil];
    [self setSongLabel:nil];
    [self setDurationLabel:nil];
    [self setTypeLabel:nil];
    [super viewDidUnload];
}
@end
