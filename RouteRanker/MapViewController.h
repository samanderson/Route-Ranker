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
#import "RouteAnnotation.h"
#import "FirstViewController.h"


@interface MapViewController : UIViewController <ToggleTracking, CLLocationManagerDelegate>
{
    BOOL track;
    NSString *routeName;
    CLLocationAccuracy accuracy;
    @private 
    Route *route;
    RouteView *routeView;

}
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *routes;
@property (copy) NSString *routeName;
@property BOOL track;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPinButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *mapTitle;
@property CLLocationAccuracy accuracy;
@property CLLocation *currLocation;
-(void) updateUserLocation;
@end

