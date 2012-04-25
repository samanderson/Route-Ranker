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
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController
@synthesize addPinButton;
@synthesize routes;
@synthesize track, mapTitle;
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize routeName, accuracy, currLocation;


- (void) toggleTracking {
    NSLog(@"toggle called");
    if(track)
    {
        NSLog(@"added Route: %@", route);
        [routes addObject:route];
        NSLog(@"%@", routes);
        route = nil;
        _annotations = nil;
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
    [_annotations addObject:annotation]; 
    [_mapView addAnnotation:annotation];
}

- (void) setAcc: (CLLocationAccuracy) a {
    accuracy = a;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self updateMapView];
    
}

-(void) viewDidLoad {
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated{
    if (track) {
        CLLocationCoordinate2D coordinate = currLocation.coordinate;  
        [self.mapView setCenterCoordinate:coordinate animated:YES];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currLocation.coordinate,2000,2000);
        [self.mapView setRegion:region animated:YES];
        mapTitle.title = routeName;
        addPinButton.enabled = YES;
    } else {
        mapTitle.title = @"Paths";
        addPinButton.enabled = NO;
    }
}

-(void) updateMapView
{
    if (track)
        self.mapView.showsUserLocation = YES;
    else 
        self.mapView.showsUserLocation = NO;
    NSLog(@"self %@",_annotations);
    NSLog(@"mapView %@",self.mapView.annotations);
    
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if(_annotations) [self.mapView addAnnotations:_annotations];
}

-(void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void) updateUserLocation {
    
}

-(void)setAnnotations:(NSMutableArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (void)viewDidUnload {
    [self setMapTitle:nil];
    [self setAddPinButton:nil];
    [super viewDidUnload];
}
- (void) locationManager:(CLLocationManager *) manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currLocation = newLocation;
    if(newLocation){
        if((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) && (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {
            if(!route)
            {
                NSLog(@"called");
                route = [[Route alloc] initWithStartPoint:newLocation];
                route.name = self.routeName;
                _annotations = [NSMutableArray arrayWithCapacity:20];
                route.annotations = _annotations;
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

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    // reuse a view, if one exists
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    // create a new view else
    if (!aView) {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    }
    
    // now configure the view
    //aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[(UIButton*)aView.rightCalloutAccessoryView addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    aView.canShowCallout = YES;
    aView.enabled = YES;
    //aView.image = [UIImage imageNamed:@"green_pin.png"];
    aView.centerOffset = CGPointMake(0, -20);
    
    return aView;
}

@end
