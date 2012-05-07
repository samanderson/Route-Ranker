//
//  Route.h
//  RouteRanker
//
//  Created by Chuck Anderson on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "RouteAnnotation.h"

@interface Route : NSObject <MKOverlay>
{
    MKMapPoint *points;
    NSMutableArray *timeArray;
    NSUInteger numPoints;
    NSUInteger pointSpace;
    NSString *name;
    
    MKMapRect boundingMapRect;
    
    pthread_rwlock_t rwLock;
    
}

-(id) initWithStartPoint: (CLLocation *) loc;

-(MKMapRect) addPoint: (CLLocation *) loc;
-(MKMapRect) addEstimatedPoint:(CLLocation *) loc withEstimatedCoordinate: (CLLocationCoordinate2D) coord;
-(double) getTotalDistanceTraveled;
-(NSTimeInterval) getTotalTimeElapsed;

-(void) lockForReading;

@property (readonly) MKMapPoint *points;
@property (readonly) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (copy) NSString *name;
@property (readonly) NSUInteger numPoints;
@property (readonly) NSUInteger numAnnotations;
@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(void) unlockForReading;

- (void) addAnnotation: (id <MKAnnotation>) a;

@end
