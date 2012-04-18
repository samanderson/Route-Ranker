//
//  Route.h
//  RouteRanker
//
//  Created by Chuck Anderson on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Route : NSObject <MKOverlay>
{
    MKMapPoint *points;
    NSMutableArray *timeArray;
    NSUInteger numPoints;
    NSUInteger pointSpace;
    NSString *name;
    
    MKMapRect boundingEdges;
    
    pthread_rwlock_t rwLock;
    
}

-(id) initWithStartPoint: (CLLocation *) loc;

-(MKMapRect) addPoint: (CLLocation *) loc;

-(void) lockForReading;

@property (readonly) MKMapPoint *points;
@property (readonly) NSMutableArray *timeArray;
@property (readonly) NSString *name;
@property (readonly) NSUInteger numPoints;

-(void) unlockForReading;

@end
