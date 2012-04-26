//
//  MapViewController.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController() {
    
}
@end

@implementation MapViewController
@synthesize addPinButton;
@synthesize routes;
@synthesize track, mapTitle;
@synthesize annotations = _annotations;
@synthesize locationManager;
@synthesize map;
@synthesize routeName, accuracy, currLocation;


- (void) toggleTracking {
    if(track)
    {
        //[routes addObject:currRoute];
        //double dist = [currRoute getTotalDistanceTraveled];
        //[map removeOverlay:currRoute];
       // if (map.annotations) {
         //   [map removeAnnotations:map.annotations];
        //}
        //routeView = nil;
        //routeName = nil;
        
    } else {
        if (map.annotations) {
            [map removeAnnotations:map.annotations];
        }
        [map removeOverlay:currRoute];
        currRoute = nil;
        _annotations = nil;
        routeView = nil;
        routeName = nil;
    }
    track = !track;
}


- (void) setName: (NSString *)name {
    routeName = name;
}

- (void) setStart: (CLLocation *) start {
    currLocation = start;
}

- (IBAction)dropPin:(id)sender {
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"New Annotation" message:@"Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    NSDate* today = [NSDate date];
    RouteAnnotation* annotation = [[RouteAnnotation alloc] initWithCoordinateAndTime: currLocation.coordinate :today];
    annotation.title = [[alertView textFieldAtIndex:0] text];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:today];
    annotation.subtitle = formattedDateString;
    [currRoute addAnnotation:annotation]; 
    [map addAnnotation:annotation];
}

- (void) setAcc: (CLLocationAccuracy) a {
    accuracy = a;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    map.delegate = self;
}

-(void) viewDidAppear:(BOOL)animated{
    if (track) {
        mapTitle.title = routeName;
        addPinButton.enabled = YES;
        map.showsUserLocation = YES;
        
        if (!currRoute)
        {
            currRoute = [[Route alloc] initWithStartPoint:currLocation];
            if (!routeName) {
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder reverseGeocodeLocation: currLocation completionHandler: 
                 ^(NSArray *placemarks, NSError *error) {
                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                     CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
                     currRoute.name = [NSString stringWithFormat:@"%@ %d/%d/%d", placemark.locality, currentDate.month, currentDate.day, currentDate.year];
                 }];
            } else {
                currRoute.name = routeName;
            }
        }
        
        if (currRoute.annotations) {
            [map addAnnotations:currRoute.annotations];
        }
        if(!routeView) {
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currLocation.coordinate, 2000, 2000);
            [map setRegion:region animated:YES];
            
            [map addOverlay:currRoute];
            _annotations = [NSMutableArray arrayWithCapacity:20];
        }
    } else {
        //mapTitle.title = @"Paths";
        addPinButton.enabled = NO;
        map.showsUserLocation = NO;
        //if (map.annotations) {
        //    [map removeAnnotations:map.annotations];
        //}
    }
}

-(void) setMapView:(MKMapView *)mapView
{
    map = mapView;
}

-(void) updateUserLocation {
    
}

-(void)setAnnotations:(NSMutableArray *)annotations
{
    _annotations = annotations;
}

- (void)viewDidUnload {
    [self setMapTitle:nil];
    [self setAddPinButton:nil];
    [super viewDidUnload];
}

- (void) locationManager:(CLLocationManager *) manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //routes = [[NSMutableArray alloc] init ];    
    currLocation = newLocation;
    if(newLocation){
        if((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) && (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {
            if(!currRoute)
            {
                currRoute = [[Route alloc] initWithStartPoint:newLocation];
                if (!routeName) {
                    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                    [geocoder reverseGeocodeLocation: newLocation completionHandler: 
                     ^(NSArray *placemarks, NSError *error) {
                         CLPlacemark *placemark = [placemarks objectAtIndex:0];
                         CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
                         currRoute.name = [NSString stringWithFormat:@"%@ %d/%d/%d", placemark.locality, currentDate.month, currentDate.day, currentDate.year];
                     }];
                } else {
                    currRoute.name = routeName;
                }
            }
            else {
                MKMapRect updateRect = [currRoute addPoint:newLocation];
                if(!MKMapRectIsNull(updateRect))
                {
                    MKZoomScale currentZoomScale = (CGFloat)(map.bounds.size.width /map.visibleMapRect.size.width);
                    CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                    updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                    [routeView setNeedsDisplayInMapRect: updateRect];
                }
            }
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(!routeView)
    {
        routeView = [[RouteView alloc] initWithOverlay:overlay];
    }
    return routeView;
}
/*
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // reuse a view, if one exists
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    // create a new view else
    if (!aView) {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    }
    
    // now configure the view
    aView.canShowCallout = YES;
    aView.enabled = YES;
    aView.centerOffset = CGPointMake(0, -20);
    
    return aView;
} */

@end
