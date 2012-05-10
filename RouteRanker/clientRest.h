//
//  clientRest.h
//  Calculator
//
//  Created by Eric Denovitzer on 4/28/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "SBJson.h"
#import "URLRequest.h"
#import "Route.h"
#import "AppDelegate.h"

@interface clientRest : NSObject
-(NSArray *)getFriends: (int)id;
-(NSArray *)getPenFriends: (int)id;
-(bool)addFriend: (int)id1 add:(int)id2;
-(bool)acceptFriend: (int)id1 accept:(int)id2;
-(bool)sharePath: (int)pathId fromUser:(int)creator withFriend:(int)userId;
-(bool)addPath:(Route *)path withId:(int)idPath ofUser:(int)id;
-(void)getPathWithId: (int)pathId ofUser:(int)userId;
- (NSString *)md5:(NSString *)str;
@end
