//
//  RouteAnnotation.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteAnnotation.h"

@interface RouteAnnotation ()

@end

@implementation RouteAnnotation

@synthesize coordinate, time, title, subtitle;

- (id)initWithCoordinateAndTime:(CLLocationCoordinate2D)coord :(NSDate *)t {
    coordinate = coord;
    time = t;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:t];
    subtitle = formattedDateString;
    return self;
}

@end
