//
//  CatalogViewController.m
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "CatalogViewController.h"
#import "ExerciseCatalog.h"
#import "ExerciseTrack.h"
#import "TrackDetailViewController.h"

@implementation CatalogViewController

@synthesize catalog;

#pragma mark lifecycle

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self fetchCatalog];
        [self.navigationItem setTitle:@"Track Catalog"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark display

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
    ExerciseTrack *track = [catalog.tracks objectAtIndex:indexPath.row];
    NSString *cellTitle = [NSString stringWithFormat:@"Release %@/Track %@",
                           [track.information objectForKey:@"release"],
                           [track.information objectForKey:@"sequence"]];
    [cell.textLabel setText:cellTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExerciseTrack *track = [catalog.tracks objectAtIndex:indexPath.row];
    TrackDetailViewController *tvc = [[TrackDetailViewController alloc]
                                      initForNewTrack:YES];
    tvc.track = track;
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark fetching

- (void)fetchCatalog
{
    jsonData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:
                  @"http://smooth-rain-7517.herokuapp.com/api"
                  @"/get/catalog"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] 
                  initWithRequest:req 
                  delegate:self
                  startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSError *err;
    catalog = [[ExerciseCatalog alloc] initWithData:[NSJSONSerialization 
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
    connection = nil;
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    connection = nil;
    jsonData = nil;
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [av show];
}

@end
