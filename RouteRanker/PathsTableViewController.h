//
//  PathsTableViewController.h
//  RouteRanker
//
//  Created by Mark Whelan on 4/30/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTableViewController.h"

@interface PathsTableViewController : UITableViewController
{
    NSString* friendToShareWith;
    NSString* pathToShare;
    NSMutableArray* listOfPaths;
}

@property (nonatomic, strong) NSString* pathToShare; //name of path to be shared, selected by user
@property (nonatomic, strong) NSString* friendToShareWith; //name of friend to share with, selected from friend table
@property (nonatomic, strong) NSMutableArray* listOfPaths;  //list of paths already logged

@end
