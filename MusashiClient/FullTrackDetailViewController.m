//
//  FullTrackDetailViewController.m
//  MusashiClient
//
//  Created by James Cash on 15-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "FullTrackDetailViewController.h"
#import "FullTrack.h"

@implementation FullTrackDetailViewController
@synthesize releaseLabel;
@synthesize trackLabel;
@synthesize kindLabel;
@synthesize songLabel;
@synthesize trackDurationLabel;
@synthesize blocksTable;
@synthesize track;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [releaseLabel 
     setText:[NSString stringWithFormat:@"Release %@", track.releaseNumber]];
    [trackLabel
     setText:[NSString stringWithFormat:@"Track %@", track.sequenceNumber]];
    [kindLabel setText:track.kind];
    [songLabel setText:track.song];
    [trackDurationLabel 
     setText:[NSString stringWithFormat:@"%@:%02d", 
              track.length_minutes, 
              [track.length_seconds intValue]]];
    [blocksTable setDataSource:self];
}

- (void)viewDidUnload
{
    [self setReleaseLabel:nil];
    [self setTrackLabel:nil];
    [self setKindLabel:nil];
    [self setSongLabel:nil];
    [self setTrackDurationLabel:nil];
    [self setBlocksTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [track.blocks count];
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    NSManagedObject *block = [[track.blocks 
                               filteredSetUsingPredicate:
                               [NSPredicate 
                                predicateWithFormat:@"sequenceNumber == %@", 
                                [NSNumber numberWithInteger:(section + 1)]]]
                              anyObject];
    return [NSString stringWithFormat:@"Block %i: %@", 
            section + 1, [block valueForKey:@"blockDescription"]]; 
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSManagedObject *block = [[track.blocks 
                               filteredSetUsingPredicate:
                               [NSPredicate 
                                predicateWithFormat:@"sequenceNumber == %@", 
                                [NSNumber numberWithInteger:(section + 1)]]]
                              anyObject];
    NSSet *sequences = [block valueForKey:@"sequences"];
    NSUInteger cnt = 0;
    for (NSManagedObject *seq in sequences) {
        cnt += [[seq valueForKey:@"moves"] count];
    }
    return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger blockNum = [indexPath indexAtPosition:0];
    NSManagedObject *block = [[track.blocks 
                              filteredSetUsingPredicate:
                              [NSPredicate 
                               predicateWithFormat:@"sequenceNumber == %@", 
                               [NSNumber numberWithInteger:(blockNum + 1)]]]
                              anyObject];
    NSUInteger currentCnt = [indexPath indexAtPosition:1];
    NSArray *sequences = [[block valueForKey:@"sequences"] 
                          sortedArrayUsingDescriptors:
                          [[NSArray alloc] 
                           initWithObjects:
                           [NSSortDescriptor 
                            sortDescriptorWithKey:@"sequenceNumber"
                                        ascending:YES], 
                           nil]];
    NSManagedObject *sequence = nil;
    NSInteger sequenceNum = 0;
    for (NSManagedObject *seq in sequences) {
        NSInteger movesForSeq = [[seq valueForKey:@"moves"] count];
        if (movesForSeq > currentCnt) {
            sequence = seq;
            break;
        } else {
            currentCnt -= movesForSeq;
            sequenceNum += 1;
        }
    }
    NSManagedObject *move = [[[sequence valueForKey:@"moves"]
                             filteredSetUsingPredicate:
                             [NSPredicate 
                              predicateWithFormat:@"sequenceNumber == %@",
                              [NSNumber numberWithInteger:currentCnt]]] 
                             anyObject];
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:
                             @"UITableViewCellSubtitled"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"UITableViewCellSubtitled"];
    }
    if (currentCnt == 0) {
        [cell.textLabel setText:[NSString 
                                 stringWithFormat:@"%i: %@", 
                                 sequenceNum + 1, 
                                 [move valueForKey:@"moveDescription"]]];
        [cell.detailTextLabel setText:[NSString
                                       stringWithFormat:
                                       @"%@ Seconds - %@ Reps - %@ Count",
                                       [sequence valueForKey:@"length"],
                                       [sequence valueForKey:@"reps"],
                                       [move valueForKey:@"count"]]];
    } else {
        [cell.textLabel setText:[NSString
                                 stringWithFormat:@"   %@",
                                 [move valueForKey:@"moveDescription"]]];
        [cell.detailTextLabel setText:[NSString
                                       stringWithFormat:@"%@ Count",
                                       [move valueForKey:@"count"]]];
    }

    return cell;
}
@end
