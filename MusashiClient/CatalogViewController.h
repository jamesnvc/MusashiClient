//
//  CatalogViewController.h
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Catalog;

@interface CatalogViewController : UITableViewController
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    Catalog *catalog;
}
@property (nonatomic, strong) Catalog *catalog;
- (void)fetchCatalog;
@end
