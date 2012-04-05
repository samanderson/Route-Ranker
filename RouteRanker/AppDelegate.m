//
//  AppDelegate.m
//  RouteRanker
//
//  Created by Chuck Anderson on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    tabBarController = [[UITabBarController alloc] init];
    
    /*UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:0];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Review" image:nil tag:1];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"Compare" image:nil tag:2];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"Share" image:nil tag:3];
    NSArray* items = [NSArray arrayWithObjects: item1, item2, item3, item4, nil];
    [tabBarController setItems:items];  */
    UIViewController* vc1 = [[UIViewController alloc] init];
    UIViewController * vc2 = [[UIViewController alloc] init];
    UIViewController* vc3 = [[UIViewController alloc] init];
    NSArray* controllers = [NSArray arrayWithObjects: vc1,vc2,vc3, nil];
    tabBarController.viewControllers = controllers;
    
    window.rootViewController = tabBarController;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
