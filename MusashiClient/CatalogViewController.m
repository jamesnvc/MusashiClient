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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    CatalogTrack *track = [catalog.tracks objectAtIndex:indexPath.row];
    NSString *cellTitle = [NSString stringWithFormat:@"Release %@/Track %@",
                           [track.information objectForKey:@"release"],
                           [track.information objectForKey:@"sequence"]];
    [cell.textLabel setText:cellTitle];
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

#pragma mark - Data fetching

- (void)fetchCatalog
{
    jsonData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:@"/api/get/catalog" relativeToURL:apiBaseURL];
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
    NSArray *selected = nil;
    

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
