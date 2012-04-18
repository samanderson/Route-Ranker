//
//  AppDelegate.h
//  RouteRanker
//
//  Created by Chuck Anderson on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
