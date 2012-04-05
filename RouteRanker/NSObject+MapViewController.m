//
//  NSObject+MapViewController.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+MapViewController.h"

@interface MapViewController() {

}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;

- (IBAction)go:(id)sender {
    [self updateUserLocation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,2000,2000);
    [self.mapView setRegion:region animated:YES]; 
}

-(void) viewDidAppear:(BOOL)animated
{
    self.mapView.showsUserLocation = YES;
   /* [self updateUserLocation]; 
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,2000,2000);
    [self.mapView setRegion:region animated:YES]; */
}

-(void) updateMapView
{
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
    MKUserLocation *userLocation = self.mapView.userLocation;
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    NSLog(@"%f", coordinate.latitude);
    NSLog(@"%f", coordinate.longitude);
    
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
