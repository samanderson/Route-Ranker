//
//  URLRequest.m
//  Calculator
//
//  Created by Eric Denovitzer on 4/22/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import "URLRequest.h"
@implementation URLRequest


- (NSString *)sendRequest: (NSString *)url withMethod:(NSString *)method andValues: (NSString *)values{
    NSURLResponse *response;
    NSError *error;
    NSString *myRequestString = values;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: 
                                    [NSURL URLWithString: url]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
     NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    if ([method isEqualToString:@"post"]) {
        [request setHTTPMethod: @"post"];
        [request setHTTPBody: myRequestData];
    }
        
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    NSString *strData = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return strData;
} 
@end
