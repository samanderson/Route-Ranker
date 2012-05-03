//
//  AutoAnnotation.m
//  RouteRanker
//
//  Created by Chuck Anderson on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AutoAnnotation.h"

@interface AutoAnnotation ()

@end

@implementation AutoAnnotation

@synthesize coordinate, time, title;

- (id)initWithCoordinateAndTime:(CLLocationCoordinate2D)coord :(NSDate *)t {
    coordinate = coord;
    time = t;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:t];
    title = formattedDateString;
    return self;
}

@end