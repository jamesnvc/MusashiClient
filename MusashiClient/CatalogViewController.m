//
//  CatalogViewController.m
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "CatalogViewController.h"
#import "PreviewCatalog.h"
#import "CatalogTrack.h"
#import "TrackDetailViewController.h"
#import "CatalogViewCell.h"
#import "FullTrackStore.h"

static NSURL *apiBaseURL = nil;

@implementation CatalogViewController

@synthesize catalog;

#pragma mark - Lifecycle

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        apiBaseURL = [NSURL URLWithString:
                      @"http://smooth-rain-7517.herokuapp.com"];
        executeBtn = [[UIBarButtonItem alloc] 
                      initWithTitle:@"Execute"
                      style:UIBarButtonItemStylePlain
                      target:self
                      action:@selector(fetchSelectedFullTracks)];
        loadingSpinner = 
        [[UIActivityIndicatorView alloc] 
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingSpinner.hidesWhenStopped = YES;
        loadingSpinner.color = [UIColor blackColor];
        loadingSpinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        loadingSpinner.center = CGPointMake(self.view.center.x, 
                                            self.view.center.y - 40.0);
        [self.view addSubview:loadingSpinner];
        [self fetchCatalog];
        [self.navigationItem setTitle:@"Track Catalog"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - Display

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [catalog.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"CatalogViewCell"];
    if (cell == nil) {
        cell = [[CatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"CatalogViewCell"];
    }
    CatalogTrack *track = [catalog.tracks objectAtIndex:indexPath.row];
    [cell setTrack:track];
    [cell setContainingController:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogTrack *track = [catalog.tracks objectAtIndex:indexPath.row];
    TrackDetailViewController *tvc = [[TrackDetailViewController alloc]
                                      initForNewTrack:YES];
    tvc.track = track;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)displayExecuteDialog
{
    self.navigationController.navigationBar.topItem.rightBarButtonItem = 
    executeBtn;
    [self.view setNeedsDisplay];
}

#pragma mark - Data fetching

- (void)fetchCatalog
{
    jsonData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:@"/api/get/catalog" 
                        relativeToURL:apiBaseURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    previewConn = [[NSURLConnection alloc] 
                  initWithRequest:req 
                  delegate:self
                  startImmediately:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [loadingSpinner startAnimating];
    
}

- (void)fetchSelectedFullTracks
{
    NSArray *selected = [catalog.tracks 
                         filteredArrayUsingPredicate:
                         [NSPredicate 
                          predicateWithBlock:^BOOL(id obj, NSDictionary *d) {
                              return ((CatalogTrack *)obj).enqueued;
                          }]];
    NSMutableArray *track_ids = [[NSMutableArray alloc] init];
    NSMutableDictionary *id_track_dict = [[NSMutableDictionary alloc] 
                                          initWithCapacity:[selected count]];
    for (CatalogTrack *trk in selected) {
        NSNumber *track_id = [trk.information objectForKey:@"id"];
        [track_ids addObject:track_id];
        [id_track_dict setObject:trk forKey:track_id];
        [trk.cell startDownloading];
    }
    [[FullTrackStore defaultStore] 
     fetchTracks:track_ids
     withCallback:^(NSNumber *tid) {
         CatalogTrack *trk = [id_track_dict objectForKey:tid];
         [trk.cell downloadFinished];
     }];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSError *err;
    catalog = [[PreviewCatalog alloc] initWithData:[NSJSONSerialization 
                                                     JSONObjectWithData:jsonData
                                                     options:0
                                                     error:&err]];
    if (err) {
        NSString *errorString = [NSString 
                                 stringWithFormat:@"Error parsing JSON: %@",
                                 [err localizedDescription]];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:errorString 
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }    
    jsonData = nil;
    previewConn = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [loadingSpinner stopAnimating];
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    previewConn = nil;
    jsonData = nil;
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [loadingSpinner stopAnimating];
    [av show];
}

@end
