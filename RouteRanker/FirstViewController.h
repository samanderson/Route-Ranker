//
//  FirstViewController.h
//  RouteRanker
//
//  Created by Chuck Anderson on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol ToggleTracking <NSObject>
@required
- (void) toggleTracking;
- (void) setName: (NSString *)name;
- (void) setAcc: (CLLocationAccuracy)accuracy;
- (void) setStart: (CLLocation *)start;
@end

@interface FirstViewController : UIViewController <UITextFieldDelegate>
{
    id <ToggleTracking> trackDelegate;
    NSString *routeName;
    BOOL track;
    CLLocationAccuracy accuracy;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
}

@property id trackDelegate;
@property id<CLLocationManagerDelegate> locationDelegate;
@property (copy) NSString *routeName;
@property BOOL track;
@property CLLocationAccuracy accuracy;
@property (weak, nonatomic) IBOutlet UITextField *routeNameText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *GPSAccuracy;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property CLGeocoder *geocoder;
@property UIGestureRecognizer *tapRecognizer;

@end
