//
//  CatalogViewController.h
//  MusashiClient
//
//  Created by James Cash on 03-02-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PreviewCatalog;

@interface CatalogViewController : UITableViewController
{
    NSURLConnection *previewConn;
    NSURLConnection *fullConn;
    NSMutableData *jsonData;
    UIActivityIndicatorView *loadingSpinner;
    PreviewCatalog *catalog;
    UIBarButtonItem *executeBtn;
}
@property (nonatomic, strong) PreviewCatalog *catalog;
- (void)fetchCatalog;
- (void)fetchSelectedFullTracks;
- (void)displayExecuteDialog;
@end
