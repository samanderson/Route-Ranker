//
//  MapViewController.h
//  RouteRanker
//
//  Created by Chuck Anderson on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Route.h"
#import "RouteView.h"
#import "FirstViewController.h"


@interface MapViewController : UIViewController <ToggleTracking>
{
    BOOL track;
    NSString *routeName;
    CLLocationAccuracy accuracy;
    @private 
    Route *route;
    RouteView *routeView;
    CLLocationManager *locationManager;

}
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (copy) NSString *routeName;
@property BOOL track;
@property CLLocationAccuracy accuracy;
-(void) updateUserLocation;
@end

