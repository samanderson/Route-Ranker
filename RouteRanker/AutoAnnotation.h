//
//  AutoAnnotation.h
//  RouteRanker
//
//  Created by Chuck Anderson on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AutoAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSDate *time;
    NSString *title;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSDate *time;
@property (nonatomic, copy) NSString *title;


- (id)initWithCoordinateAndTime:(CLLocationCoordinate2D)coordinate :(NSDate *)time;

@end