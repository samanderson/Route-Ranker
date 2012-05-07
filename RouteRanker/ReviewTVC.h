//
//  ReviewTVC.h
//  RouteRanker
//
//  Created by Mark Whelan on 5/1/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewGroupTVC.h"
#import "EditGroupsTVC.h"
#import "CompareVC.h"
#import "Group.h"
#import "Route.h"
#import <MapKit/MapKit.h>

@class ReviewTVC;

@protocol reviewDelegate
- (NSMutableArray*) getNewListOfGroups;
@end

@interface ReviewTVC : UITableViewController {
    NSMutableArray * ListOfGroups;
    NSMutableArray* listOfGroupNames;
    NSString* NewGroupName;
    NSMutableArray* listOfRoutes; 
}

@property (nonatomic, strong) NSMutableArray* listOfRoutes;   //list of all routes on the phone
@property (nonatomic, strong) NSMutableArray* listOfGroupNames; //list of groups names (NSSTring*) created by user
@property (nonatomic, weak) id <reviewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* ListOfGroups;   //list of Group* groups created by user
@property (nonatomic, strong) NSString* NewGroupName;    //nam of group typed by user when they click the first cell


@end
