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

@synthesize track;
@synthesize routeName;
@synthesize trackDelegate;
@synthesize accuracy;
@synthesize routeNameLabel;
@synthesize GPSAccuracy;


- (IBAction)TrackingStarted:(id)sender {
    [[self trackDelegate] toggleTracking];
    routeName = routeNameLabel.text;
    if(GPSAccuracy.selectedSegmentIndex == 0)
    {
        accuracy = kCLLocationAccuracyNearestTenMeters;
    }
    else if (GPSAccuracy.selectedSegmentIndex == 1)
    {
        accuracy = kCLLocationAccuracyBest;
    }
    else {
        accuracy = kCLLocationAccuracyBestForNavigation;
    }
    [[self trackDelegate] setName: routeName];
    [[self trackDelegate] setAcc: accuracy];
    UIButton *button = (UIButton *) sender;
    if([button.titleLabel.text isEqualToString: @"Start"]) {
        [button setTitle:@"Stop" forState: UIControlStateNormal];
    }
    else {
        [button setTitle:@"Start" forState:UIControlStateNormal];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTrackDelegate:[self.tabBarController.viewControllers objectAtIndex: 1]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setGPSAccuracy:nil];
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
