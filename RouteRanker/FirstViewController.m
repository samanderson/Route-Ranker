//
//  FirstViewController.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize track, routeName, routeNameText, trackDelegate, accuracy, GPSAccuracy;
@synthesize tapRecognizer, locationManager, locationDelegate, geocoder;


- (IBAction)TrackingStarted:(id)sender {
    [trackDelegate toggleTracking];
    UIButton *button = (UIButton *) sender;
    if([button.titleLabel.text isEqualToString: @"Start"]) {
        [button setTitle:@"Stop" forState: UIControlStateNormal];
        routeNameText.enabled = NO;
        routeNameText.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
        [locationManager startUpdatingLocation];
        if(GPSAccuracy.selectedSegmentIndex == 0)
            accuracy = kCLLocationAccuracyNearestTenMeters;
        else if (GPSAccuracy.selectedSegmentIndex == 1)
            accuracy = kCLLocationAccuracyBest;
        else
            accuracy = kCLLocationAccuracyBestForNavigation;
        while (!locationManager.location) {
            // get a location
        }
        if (routeNameText.text && ![routeNameText.text isEqualToString:@""]) {
            routeName = routeNameText.text;
            [trackDelegate setName: routeName];
        } else {
            [geocoder reverseGeocodeLocation: locationManager.location completionHandler: 
             ^(NSArray *placemarks, NSError *error) {
                 
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
                 routeName = [NSString stringWithFormat:@"%@ %d/%d/%d", placemark.locality, currentDate.month, currentDate.day, currentDate.year];
                 routeNameText.text = routeName;
                 [trackDelegate setName: routeName];
             }];
        }
        
        [trackDelegate setAcc: accuracy];
        [trackDelegate setStart: locationManager.location];
    }
    else {
        [button setTitle:@"Start" forState:UIControlStateNormal];
        routeNameText.enabled = YES;
        routeNameText.backgroundColor = [UIColor whiteColor];
        routeNameText.text = @"";
        [locationManager stopUpdatingLocation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTrackDelegate:[self.tabBarController.viewControllers objectAtIndex: 1]];
    routeNameText.delegate = self;
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapRecognizer.enabled = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    locationManager = [[CLLocationManager alloc] init];
    [self setLocationDelegate:[self.tabBarController.viewControllers objectAtIndex: 1]]; 
    locationManager.delegate = locationDelegate;
    geocoder = [[CLGeocoder alloc] init];

	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    tapRecognizer.enabled = NO;
	[textField resignFirstResponder];
	return YES;
}

- (void)singleTap:(id)sender
{
	[routeNameText resignFirstResponder];
    tapRecognizer.enabled = NO;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    tapRecognizer.enabled = YES;
    return YES;
}

- (BOOL)textFieldShouldFinishEditing:(UITextField *)textField { 
	return YES;
}

- (void)viewDidUnload
{
    [self setGPSAccuracy:nil];
    [self setRouteNameText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
