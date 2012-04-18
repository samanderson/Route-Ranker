//
//  Route.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
// kCLLocationAccuracyBest (gps) 
// kCLLocationAccuracyBestForNavigation;
// kCLLocationAccuracyNearestTenMeters
//

#import "Route.h"

#define INITIAL_POINT_SPACE 1000
#define MINIMUM_DELTA_METERS 10.0

@implementation Route

@synthesize points, numPoints, timeArray, name;

-(id) initWithStartPoint:(CLLocation *)loc
{
    self = [super init];
    if (self)
    {
        CLLocationCoordinate2D coord = loc.coordinate;
        MKMapPoint point= MKMapPointForCoordinate(coord);
        NSDate *timeStamp = [loc.timestamp copy];
        pointSpace = INITIAL_POINT_SPACE;
        points = malloc(sizeof(MKMapPoint) * pointSpace);
        timeArray = [NSMutableArray arrayWithCapacity:pointSpace]; 
        [timeArray addObject:timeStamp];
        points[0] = point;
        numPoints = 1;
        
        MKMapPoint center = point;
        center.x -= MKMapSizeWorld.width /8.0;
        center.y -= MKMapSizeWorld.height / 8.0;
        MKMapSize size = MKMapSizeWorld;
        size.width /= 4.0;
        size.height /=4.0;
        boundingEdges = MKMapRectMake(center.x,center.y,size.width,size.height); 
        MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
        boundingEdges = MKMapRectIntersection(boundingEdges, worldRect);
        
        pthread_rwlock_init(&rwLock, NULL);
    }
    return self;
    
}

-(CLLocationCoordinate2D) coordinate
{
    return MKCoordinateForMapPoint(points[0]);
}

-(MKMapRect) boundingEdges 
{
    return boundingEdges;
}
-(void) lockForReading
{
    pthread_rwlock_rdlock(&rwLock);
}

-(MKMapRect) addPoint:(CLLocation *)loc
{
    pthread_rwlock_wrlock(&rwLock);
    
    MKMapPoint newPoint = MKMapPointForCoordinate(loc.coordinate);
    MKMapPoint prevPoint = points[numPoints -1];

    CLLocationDistance metersApart = MKMetersBetweenMapPoints(newPoint, prevPoint);
    MKMapRect updateRect = MKMapRectNull;
    
    if(metersApart > MINIMUM_DELTA_METERS)
    {
        NSDate *newDate = [loc.timestamp copy];

        if (pointSpace == numPoints)
        {
            pointSpace *= 2;
            points = realloc(points, sizeof(MKMapPoint) * pointSpace);
        }
        [timeArray addObject:newDate];
        points[numPoints] = newPoint;
        numPoints++;
        
        double minX = MIN(newPoint.x, prevPoint.x);
        double minY = MIN(newPoint.y, prevPoint.y);
        double maxX = MAX(newPoint.x, prevPoint.x);
        double maxY = MAX(newPoint.y, prevPoint.y);
        
        updateRect = MKMapRectMake(minX, minY, maxX-minX, maxY- minY);
    }
    
    pthread_rwlock_unlock(&rwLock);
    
    return updateRect;
}

@end
