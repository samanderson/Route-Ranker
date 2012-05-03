//
//  Group.h
//  RouteRanker
//
//  Created by Chuck Anderson on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

@interface Group : NSObject
{
    NSMutableArray *_routeNames;
    double _avgDist;
    double _avgSpeed;
    double _totalTime;
    NSMutableArray *_times;
    NSString *_groupName;
}

@property (copy) NSString * groupName;
@property (nonatomic, strong) NSMutableArray * routeNames;
@property double avgDist;
@property double avgSpeed;
@property double totalTime;
@property (nonatomic, strong) NSMutableArray * times;

-(id) initWithName: (NSString *) name;

-(void) addRoute: (Route *) route; 

-(void) removeRoute: (Route *) route;

-(double) getAvgMPH;

-(double) getAvgMiles;

//returns in seconds
-(double) getShortestTime;

//returns in seconds
-(double) getLongestTime;

@end
