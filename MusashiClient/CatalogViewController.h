//
//  CatalogViewController.h
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExerciseCatalog;

@interface CatalogViewController : UITableViewController
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    UIActivityIndicatorView *loadingSpinner;
    ExerciseCatalog *catalog;
}
@property (nonatomic, strong) ExerciseCatalog *catalog;
- (void)fetchCatalog;
@end
