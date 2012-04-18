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
@end

@interface FirstViewController : UIViewController
{
    id <ToggleTracking> trackDelegate;
    NSString *routeName;
    BOOL track;
    CLLocationAccuracy accuracy;
}

@property id trackDelegate;
@property (copy) NSString *routeName;
@property BOOL track;
@property CLLocationAccuracy accuracy;
@property (weak, nonatomic) IBOutlet UITextField *routeNameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *GPSAccuracy;

@end
