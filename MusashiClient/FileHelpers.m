//
//  FileHelpers.m
//  Homepwner
//
//  Created by James Cash on 11-09-16.
//  Copyright 2011 University of Toronto. All rights reserved.
//

#import "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
    NSArray *documentDirs = 
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                            NSUserDomainMask, YES);
    NSString *documentDir = [documentDirs objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:fileName];
}