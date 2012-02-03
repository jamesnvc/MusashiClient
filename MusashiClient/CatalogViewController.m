//
//  CatalogViewController.m
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "CatalogViewController.h"

@implementation CatalogViewController

@synthesize catalog;

#pragma mark lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self fetchCatalog];
    }
    return self;
}

#pragma mark display

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark fetching

- (void)fetchCatalog
{
    
}

@end
