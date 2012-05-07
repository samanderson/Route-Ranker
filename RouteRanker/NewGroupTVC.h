//
//  NewGroupTVC.h
//  RouteRanker
//
//  Created by Mark Whelan on 5/1/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewTVC.h"
#import "Route.h"
#import "Group.h"



@interface NewGroupTVC : UITableViewController {
    NSString* nameOfGroup;
    Group* groupToCreate;
    NSMutableArray* listOfPaths;
    NSMutableArray* listOfRoutes;
    NSMutableArray* routesInNewGroup;
    NSMutableArray* listOfGroups;
}

@property (nonatomic, strong) Group* groupToCreate; //group to be created
@property (nonatomic, strong) NSString* nameOfGroup; //name of the newly created group
@property (nonatomic, strong) NSMutableArray* listOfPaths; //list of all path names stored on phone
@property (nonatomic, strong) NSMutableArray* listOfRoutes; //list of routes stored on phone
@property (nonatomic, strong) NSMutableArray* routesInNewGroup; //array of paths selected by user
@property (nonatomic, strong) NSMutableArray* listOfGroups; //list of groups, current group will be added if at least one path is selected

- (NSMutableArray*) getNewListOfGroups;

@end
