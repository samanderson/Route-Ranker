//
//  MapViewController.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Route.h"

@interface MapViewController() {

}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

@synthesize track;
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize routeName;
@synthesize accuracy;
@synthesize locationManager;




- (void) toggleTracking {
    track = !track;
}


- (void) setName: (NSString *)name {
    routeName = name;  
}


- (void) setAcc: (CLLocationAccuracy) a {
    accuracy = a;
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"HELLO WORLD");
    [self updateMapView];

}

-(void) viewDidLoad {
    NSLog(@"view did load");
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = accuracy;
    [self.locationManager startUpdatingLocation];
}

-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
    if(track){
    [self updateUserLocation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,2000,2000);
    [self.mapView setRegion:region animated:YES];
    }
}

-(void) updateMapView
{
    if (track)
        self.mapView.showsUserLocation = YES;
    else 
        self.mapView.showsUserLocation = NO;
    
        
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if(self.annotations) [self.mapView addAnnotations:self.annotations];
}
-(void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}
-(void) updateUserLocation
{
    if(track){
    MKUserLocation *userLocation = self.mapView.userLocation;
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;    
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void) locationManager:(CLLocationManager *) manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(newLocation){
        if((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) && (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {
            if(!route)
            {
                route = [[Route alloc] initWithStartPoint:newLocation];
                [self.mapView addOverlay:route];
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
                [self.mapView setRegion:region animated:YES];
            
            }
            else {
                MKMapRect updateRect = [route addPoint:newLocation];
                if(!MKMapRectIsNull(updateRect))
                {
                   MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width /self.mapView.visibleMapRect.size.width);
                   CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                   updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                   [routeView setNeedsDisplayInMapRect: updateRect];
                }
            }
        }
    }
}

-(MKOverlayView *) mapView: (MKMapView *) mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(!routeView)
    {
        routeView = [[RouteView alloc] initWithOverlay:overlay];
    }
    return routeView;
}
@end
