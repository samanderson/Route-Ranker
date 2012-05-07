//
//  URLRequest.h
//  Calculator
//
//  Created by Eric Denovitzer on 4/22/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URLRequest : NSURLResponse
- (NSString *)sendRequest:(NSString *)url withMethod:(NSString *) method andValues:(NSString *)values;
@end
