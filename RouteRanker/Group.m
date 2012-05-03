//
//  Group.m
//  RouteRanker
//
//  Created by Chuck Anderson on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Group.h"

@implementation Group

@synthesize avgDist = _avgDist;
@synthesize avgSpeed = _avgSpeed;
@synthesize totalTime = _totalTime;
@synthesize times = _times;
@synthesize groupName = _groupName;
@synthesize routeNames = _routeNames;

-(id) initWithName: (NSString *) name
{
    self = [super init];
    if(self)
    {
        self.groupName = name;
        self.times = [[NSMutableArray alloc] init ];
        self.routeNames = [[NSMutableArray alloc] init];
        self.avgDist = 0.0;
        self.avgSpeed = 0.0;
    }
    return self;
}

-(void) addRoute: (Route *) route
{
    double time = [route getTotalTimeElapsed];
    double dist = [route getTotalDistanceTraveled];
    int numRoutes = [self.routeNames count];
    double totalDistance = numRoutes * self.avgDist + dist;
    self.totalTime += time;
    [self.routeNames addObject:route.name];
    [self.times addObject:[[NSNumber alloc] initWithDouble:time]];
    self.avgDist = totalDistance / (numRoutes + 1);
    self.avgSpeed = totalDistance/ self.totalTime;
}

-(void) removeRoute: (Route *) route
{
    double timeElapsed = [route getTotalTimeElapsed];
    double dist = [route getTotalDistanceTraveled];
    int numRoutes = [self.routeNames count];
    NSNumber * time = [[NSNumber alloc] initWithDouble:timeElapsed];
    for(NSString * s in self.routeNames)
    {
        if([s isEqualToString:route.name])
        {
            [self.routeNames removeObject:s];
            break;
        }
    }
    for(NSNumber * t in self.times)
    {
        
        if([t isEqualToNumber:time])
        {
            [self.times removeObject:t];
            break;
        } 
    }
    self.totalTime -= timeElapsed;
    self.avgDist = (self.avgDist * numRoutes - dist)/ (numRoutes -1);
    self.avgSpeed = self.avgDist * (numRoutes -1) / self.totalTime;
}
-(double) getAvgMPH
{
    return (self.avgSpeed * 2.23693629);
}

-(double) getAvgMiles
{
    return (self.avgDist * 0.000621371192);
}

-(double) getShortestTime
{
    double smallest = [[self.times objectAtIndex:0] doubleValue];
    for(NSNumber * t in self.times)
    {
        if(smallest > [t doubleValue])
            smallest = [t doubleValue];
    }
    return smallest;
}

-(double) getLongestTime
{
    double longest = [[self.times objectAtIndex:0] doubleValue];
    for(NSNumber * t in self.times)
    {
        if(longest < [t doubleValue])
            longest = [t doubleValue];
    }
    return longest;
}

@end
