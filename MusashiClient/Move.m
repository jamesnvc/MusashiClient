//
//  Move.m
//  MusashiClient
//
//  Created by James Cash on 16-03-12.
//  Copyright (c) 2012 University of Toronto. All rights reserved.
//

#import "Move.h"


@implementation Move

@dynamic count;
@dynamic moveDescription;
@dynamic sequenceNumber;
@dynamic sequence;

- (NSString *)moveDescriptionNub
{
    NSError *err = nil;
    NSString *extracted = [self moveDescription];
    NSArray *regexChain = [NSArray arrayWithObjects:
                           @"^[A-Z][0-9]?:\\s*",
                           @"\\b(L|R|F|B|OTS)\\b.*$", 
                           @"\\s+-\\s+.*$",
                           @"\\[(rotate|Repeat|eye) (icon|logo)\\]\\s*",
                           @"^\\d+x\\s*",
                           nil];
    NSRegularExpression *extractingRegex = nil;
    for (NSString *regex in regexChain) {
        extractingRegex = [NSRegularExpression
                           regularExpressionWithPattern:regex
                           options:0
                           error:&err];
        if (err) {
            NSLog(@"Error in regular expression: %@", err);
            return nil;
        }
        extracted = [extractingRegex
                     stringByReplacingMatchesInString:extracted
                     options:0
                     range:NSMakeRange(0, [extracted length])
                     withTemplate:@""];
    }
    return extracted;    
}

@end
