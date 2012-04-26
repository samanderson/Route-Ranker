//
//  RouteAnnotation.h
//  RouteRanker
//
//  Created by Chuck Anderson on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSDate *time;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSDate *time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


- (id)initWithCoordinateAndTime:(CLLocationCoordinate2D)coordinate :(NSDate *)time;

@end