//
//  EditGroupsTVC.h
//  RouteRanker
//
//  Created by Mark Whelan on 5/1/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "specificGroupToEditTVC.h"

@interface EditGroupsTVC : UITableViewController {
    NSMutableArray* listOfGroups; //this is an array of all current groups
    NSMutableArray* listOfGroupNames;
    NSMutableArray* listOfRoutes; 
}

@property (nonatomic, strong) NSMutableArray* listOfGroupNames; 
@property (nonatomic, strong) NSMutableArray* listOfGroups;
@property (nonatomic, strong) NSMutableArray* listOfRoutes; 

@end
