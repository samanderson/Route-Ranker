//
//  clientRest.h
//  Calculator
//
//  Created by Eric Denovitzer on 4/28/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Route.h"

@interface clientRest : NSObject
-(NSArray *) getFriends: (int)id;
-(NSArray *) getPenFriends: (int)id;
-(bool) addFriend: (int)id1 add:(int)id2;
-(bool) acceptFriend: (int)id1 accept:(int)id2;
-(bool) sharePath: (int)pathId withFriend:(int)userId;
-(bool) addPath:(Route *)path ofUser:(int)id;
@end
