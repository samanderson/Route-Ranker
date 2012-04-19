//
//  RouteView.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteView.h"
#import "Route.h"

@interface RouteView (FileInternal)
- (CGPathRef)newPathForPoints: (MKMapPoint *) points 
                   pointCount:(NSUInteger)numPoints
                        times:(NSMutableArray *) timeArray
                     clipRect:(MKMapRect) mapRect
                    zoomScale: (MKZoomScale) zoomScale;
@end

@implementation RouteView

- (void) drawMapRect: (MKMapRect) mapRect
          zoomScale:(MKZoomScale)zoomScale 
          inContext:(CGContextRef)context
{
    Route *route = (Route *) self.overlay;
    CGFloat lineWidth = MKRoadWidthAtZoomScale(zoomScale);
    
    MKMapRect clipRect = MKMapRectInset(mapRect, -lineWidth, -lineWidth);
    
    [route lockForReading];
    CGPathRef path = [self newPathForPoints:route.points pointCount:route.numPoints times:route.timeArray clipRect:clipRect zoomScale:zoomScale];
    
    [route unlockForReading];
    
    if(path != nil)
    {
        CGContextAddPath(context, path);
        CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 1.0f, 0.5f);
        CGContextSetLineJoin(context,kCGLineJoinRound );
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, lineWidth);
        CGContextStrokePath(context);
        CGPathRelease(path);
    }
}
@end

@implementation RouteView (FileInternal)

static BOOL lineIntersectsRect(MKMapPoint p0, MKMapPoint p1, MKMapRect rect)
{
    double minX = MIN(p0.x, p1.x);
    double minY = MIN(p0.y, p1.y);
    double maxX = MAX(p0.x, p1.x);
    double maxY = MAX(p0.y, p1.y);
    
    MKMapRect newR = MKMapRectMake(minX, minY, maxX- minX, maxY-minY);
    return MKMapRectIntersectsRect(rect, newR);
    
}

#define MIN_POINT_DELTA 5.0

- (CGPathRef) newPathForPoints:(MKMapPoint *)points pointCount:(NSUInteger)numPoints clipRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale
{

    if (numPoints < 2)
        return NULL;
    CGMutablePathRef path = NULL;
    BOOL needsMove = YES;

#define POW2(a) ((a) * (a))
    double minPointDelta = MIN_POINT_DELTA / zoomScale;
    double c2 = POW2(minPointDelta);
    
    MKMapPoint point, lastPoint = points[0];
    NSUInteger i;
    for (i =1; i < numPoints -1; i++)
    {
        point = points[i];  
        double diag = POW2(point.x - lastPoint.x) + POW2(point.y - lastPoint.y);
        if (diag >= c2)
        {
            if (lineIntersectsRect(point,lastPoint , mapRect))
                {
                    if(!path)
                        path = CGPathCreateMutable();
                    if(needsMove)
                    {
                        CGPoint lastCGPoint = [self pointForMapPoint:lastPoint];
                        CGPathAddLineToPoint(path, NULL, lastCGPoint.x, lastCGPoint.y);
                    }
                    CGPoint cgPoint = [self pointForMapPoint:point];
                    CGPathAddLineToPoint(path, NULL, cgPoint.x, cgPoint.y);
                }
            else 
                {
                    needsMove = YES;
                }
                lastPoint = point;
        }
                    
    }
#undef POW2
                
                    
        
    if(lineIntersectsRect(lastPoint,point, mapRect))
    {
        if(!path)
            path = CGPathCreateMutable();
        if(needsMove)
        {
            CGPoint lastCGPoint = [self pointForMapPoint:lastPoint];
            CGPathMoveToPoint(path, NULL, lastCGPoint.x, lastCGPoint.y);
        }
        CGPoint cgPoint = [self pointForMapPoint:point];
        CGPathAddLineToPoint(path, NULL, cgPoint.x, cgPoint.y);
    }
    return path;
                   
}
@end
