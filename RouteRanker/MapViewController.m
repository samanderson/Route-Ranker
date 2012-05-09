//
//  MapViewController.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


#define IGNORE_POINT 3
#define KALMAN_TIME 1.0
#define CRUMB_POINTS 5

@interface MapViewController() {
    
}
@end

@implementation MapViewController
@synthesize addPinButton, timer;
@synthesize routes, track, mapTitle;
@synthesize annotations = _annotations;
@synthesize locationManager;
@synthesize map;
@synthesize routeName, currLocation;
@synthesize filter, estLat, estLong, estCoordinate;

@synthesize managedObjectContext, fetchedResultsController;



- (void) toggleTracking {
    track = !track;
    // STOP
    if(!track)
    {
        //[routes addObject:currRoute];
        //double dist = [currRoute getTotalDistanceTraveled];
        //[map removeOverlay:currRoute];
       // if (map.annotations) {
         //   [map removeAnnotations:map.annotations];
        //}
        //routeView = nil;
        //routeName = nil;
        
        if (currRoute) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];            
            NSInteger numRoutes = [prefs integerForKey:@"numRoutes"];
            numRoutes++;
            [prefs setInteger:numRoutes forKey:@"numRoutes"];
            [prefs synchronize];
            
            NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            RouteData *routeData = [NSEntityDescription insertNewObjectForEntityForName:@"RouteData" inManagedObjectContext:context];
            routeData.owner = [NSNumber numberWithInt: 1];
            routeData.idNo = [NSNumber numberWithInt: numRoutes];
            routeData.distance = [NSNumber numberWithDouble:[currRoute getTotalDistanceTraveled]];
            routeData.title = currRoute.name;
            routeData.numAnnotations = [NSNumber numberWithInt: currRoute.numAnnotations];
            routeData.numPoints = [NSNumber numberWithInt: currRoute.numPoints];
            routeData.time = [NSNumber numberWithDouble:[currRoute getTotalTimeElapsed]];
           
            
            //Save to server
            clientRest *client = [[clientRest alloc] init];
            int idOwner = [routeData.owner intValue];
            int routeNumber = [routeData.owner intValue];
            [client addPath:currRoute withId: routeNumber ofUser: idOwner];
            
            MKMapPoint *points = currRoute.points;
            NSMutableArray *times = currRoute.timeArray;
            
            NSMutableArray *mapPoints = [NSMutableArray arrayWithCapacity:currRoute.numPoints];
            for (int i = 0; i < currRoute.numPoints; i++) {
                MapPointData *mapPoint = [NSEntityDescription insertNewObjectForEntityForName:@"MapPointData" inManagedObjectContext:context];
                mapPoint.sequence = [NSNumber numberWithInt: i];
                mapPoint.timestamp = [times objectAtIndex:i];
                mapPoint.x = [NSNumber numberWithDouble:points[i].x];
                mapPoint.y = [NSNumber numberWithDouble:points[i].y];
                NSLog(@"MP: ");
                mapPoint.route = routeData;
                [mapPoints addObject:mapPoint];
            }
            routeData.points = [NSSet setWithArray:mapPoints];

            if (currRoute.annotations) {
                NSMutableArray *annotations = currRoute.annotations;
                NSMutableArray *annotationData = [NSMutableArray arrayWithCapacity:currRoute.numAnnotations];
                id<MKAnnotation> a;
                for (int i = 0; i < currRoute.numAnnotations; i++) {
                    AnnotationData *annotation = [NSEntityDescription insertNewObjectForEntityForName:@"AnnnotationData" inManagedObjectContext:context];
                    a = [annotations objectAtIndex:i];
                    annotation.type = [annotation isKindOfClass:[AutoAnnotation class]] ? @"auto" : @"route";
                    annotation.title = a.title;
                    annotation.subtitle = a.subtitle;
                    annotation.latitude = [NSNumber numberWithDouble:a.coordinate.latitude];
                    annotation.longitude = [NSNumber numberWithDouble:a.coordinate.longitude];
                    annotation.route = routeData;
                    [annotationData addObject:annotation];
                }
                routeData.annotations = [NSSet setWithArray:annotationData];
            } else {
                routeData.annotations = nil;
            }
             
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
        
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"RouteData"
                                                  inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            for (RouteData *route in fetchedObjects) {
                NSLog(@"Title: %@", route.title);
                NSLog(@"Distance: %f", [route.distance doubleValue]);
                NSLog(@"routeID: %d", [route.idNo intValue]);
            }
        }
        
        free_filter(filter);
        numPoints = 0;
        [timer invalidate];
        viewedInMap = NO;
    }
    // START
    else {
        if (map.annotations) {
            [map removeAnnotations:map.annotations];
        }
        [map removeOverlay:currRoute];
        currRoute = nil;
        _annotations = nil;
        routeView = nil;
        routeName = nil;
        filter = alloc_filter_velocity2d(1.0);
        timer = [NSTimer scheduledTimerWithTimeInterval:KALMAN_TIME target:self selector:@selector(kalmanUpdate) userInfo:nil repeats:YES];
    }
    
}
                        
- (void) kalmanUpdate {
    if (numPoints >= IGNORE_POINT) {
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
            if (!routeView) {
                [map addOverlay:currRoute];
            }
        }
        //NSLog(@"Distance between points %f", [currLocation distanceFromLocation:prevLocation]);
        //if([currLocation distanceFromLocation:prevLocation] < (100 * KALMAN_TIME))
        //{
        
            update_velocity2d(filter, currLocation.coordinate.latitude, currLocation.coordinate.longitude, KALMAN_TIME);
            if (numPoints % CRUMB_POINTS == 0 && currLocation.coordinate.latitude != prevLocation.coordinate.latitude && currLocation.coordinate.longitude != prevLocation.coordinate.longitude) {
                NSDate* today = [NSDate date];
                AutoAnnotation* autoAnnotation = [[AutoAnnotation alloc] initWithCoordinateAndTime: estCoordinate :today];
                [currRoute addAnnotation:autoAnnotation];
                [map addAnnotation:autoAnnotation];
            }
         
        //} else {
        //    update_velocity2d(filter, prevLocation.coordinate.latitude, prevLocation.coordinate.longitude, KALMAN_TIME);            
        //}
        get_lat_long(filter, &estLat ,&estLong);
        estCoordinate.latitude = estLat;
        estCoordinate.longitude = estLong;
        MKMapRect updateRect = [currRoute addEstimatedPoint:currLocation withEstimatedCoordinate:estCoordinate];
        //moved so it would not add a crumb on an outlier point. 
        /*if (numPoints % CRUMB_POINTS == 0 && currLocation.coordinate.latitude != prevLocation.coordinate.latitude && currLocation.coordinate.longitude != prevLocation.coordinate.longitude) {
            NSDate* today = [NSDate date];
            AutoAnnotation* autoAnnotation = [[AutoAnnotation alloc] initWithCoordinateAndTime: estCoordinate :today];
            [map addAnnotation:autoAnnotation];
        }*/
        if(!MKMapRectIsNull(updateRect))
        {
            MKZoomScale currentZoomScale = (CGFloat)(map.bounds.size.width /map.visibleMapRect.size.width);
            CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
            [routeView setNeedsDisplayInMapRect: updateRect];
        }
    }
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
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    NSDate* today = [NSDate date];
    RouteAnnotation* annotation = [[RouteAnnotation alloc] initWithCoordinateAndTime: currLocation.coordinate :today];
    annotation.title = [[alertView textFieldAtIndex:0] text];
    [currRoute addAnnotation:annotation];
    [map addAnnotation:annotation];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    map.delegate = self;
    //viewedInMap = NO;
    numPoints = 0;
    if (currRoute) {
        [map addOverlay:currRoute];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    map.showsUserLocation = track;
    if (track) {
        addPinButton.enabled = YES;
        if (routeName)
            mapTitle.title = routeName;
        else {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation: currLocation completionHandler: 
             ^(NSArray *placemarks, NSError *error) {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
                 mapTitle.title = [NSString stringWithFormat:@"%@ %d/%d/%d", placemark.locality, currentDate.month, currentDate.day, currentDate.year];
             }];            
        }
        if (currRoute && currRoute.annotations) {
            [map addAnnotations:currRoute.annotations];
        }
        if (!viewedInMap) {
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currLocation.coordinate, 2000, 2000);
            [map setRegion:region animated:YES];
            _annotations = [NSMutableArray arrayWithCapacity:20];
            viewedInMap = YES;
        }
    } else {
        addPinButton.enabled = NO;
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
    numPoints++;
    if (newLocation && numPoints >= IGNORE_POINT) {
        if((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) && (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {
            if(!prevLocation)
                prevLocation = currLocation;
            if([newLocation distanceFromLocation:prevLocation] < 100 *KALMAN_TIME)
                prevLocation = currLocation;
            currLocation = newLocation; 
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


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    if ([annotation isKindOfClass:[RouteAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* RouteAnnotationIdentifier = @"routeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [map dequeueReusableAnnotationViewWithIdentifier:RouteAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:RouteAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;

            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else if ([annotation isKindOfClass:[AutoAnnotation class]])
    {
        static NSString* AutoAnnotationIdentifier = @"AutoAnnotationIdentifier";
        MKAnnotationView* annotationView =
        (MKAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:AutoAnnotationIdentifier];
        if (!annotationView)
        {
            
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:AutoAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            UIImage *dotImage = [UIImage imageNamed:@"aqua_dot.png"];
            annotationView.image = dotImage;
            return annotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    } else {
        return nil;
    }
}
    

@end
