//
//  ShareTableViewController.h
//  RouteRanker
//
//  Created by Mark Whelan on 4/28/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PathsTableViewController.h"


@interface ShareTableViewController : UITableViewController
{
    NSMutableArray* nameOfFriends;
    NSArray* tableData;
    NSString* FriendToShareWith;
}

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@property (nonatomic, strong) NSArray* tableData; //array of arrays holding data for table
@property (nonatomic, strong) NSMutableArray* nameOfFriends;  //list of all facebook friends
@property (nonatomic, strong) NSString* FriendToShareWith;  //friend selected from table

@end
