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
#import "kalman.h"
#import "gps.h"
#import "AutoAnnotation.h"
#import "RouteData.h"
#import "MapPointData.h"
#import "AnnotationData.h"
#import "AppDelegate.h"

@interface MapViewController : UIViewController <ToggleTracking,MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>
{
    BOOL track;
    NSString *routeName;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext* managedObjectContext;
    @private 
    MKMapView *map;
    RouteView *routeView;
    Route * currRoute;
    int numPoints;
    CLLocation *prevLocation;
    BOOL viewedInMap;
}

@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *routes;
@property (copy) NSString *routeName;
@property BOOL track;
@property KalmanFilter  filter;
@property double estLat;
@property double estLong;
@property CLLocationCoordinate2D estCoordinate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPinButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *mapTitle;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property CLLocation *currLocation;
@property NSTimer *timer;
@property (nonatomic, retain)CLLocationManager *locationManager;
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


-(void) updateUserLocation;
@end

