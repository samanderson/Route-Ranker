//
//  NSObject+MapViewController.h
//  RouteRanker
//
//  Created by Chuck Anderson on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations;
-(void) updateUserLocation;
@end

