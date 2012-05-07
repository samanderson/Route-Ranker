//
//  specificGroupToEditTVC.h
//  RouteRanker
//
//  Created by Mark Whelan on 5/2/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#include "Route.h"


@interface specificGroupToEditTVC : UITableViewController {
    Group* groupToEdit;
    NSMutableArray* listOfRoutes;
}

@property (nonatomic, strong) NSMutableArray* listOfRoutes; //array of all routes created by the user
@property (nonatomic, strong) Group* groupToEdit; //group clicked on by user to edit

@end
