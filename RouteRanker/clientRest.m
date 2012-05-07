//
//  clientRest.m
//  Calculator
//
//  Created by Eric Denovitzer on 4/28/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import "clientRest.h"
#import "SBJson.h"
#import "URLRequest.h"


@implementation clientRest
NSString const * 
baseURL = @"http://ec2-177-71-143-149.sa-east-1.compute.amazonaws.com:8080/";

-(NSArray *) getFriends: (int)id {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *idStr = [NSString stringWithFormat:@"%d", id];
    NSString *dir = [@"get/friends/" stringByAppendingString:idStr];
    NSString *url = [baseURL stringByAppendingString: dir];
    NSString *data = [request sendRequest:url withMethod:@"get" andValues:@""];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObject = [jsonParser objectWithString:data error:&error];
    NSArray *friends = [jsonObject valueForKey:@"friends"];
    return friends;
}

-(NSArray *) getPenFriends: (int)id {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *idStr = [NSString stringWithFormat:@"%d", id];
    NSString *dir = [@"get/penFriends/" stringByAppendingString:idStr];
    NSString *url = [baseURL stringByAppendingString: dir];
    NSString *data = [request sendRequest:url withMethod:@"get" andValues:@""];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObject = [jsonParser objectWithString:data error:&error];
    NSArray *penFriends = [jsonObject valueForKey:@"penFriends"];
    return penFriends;
}

-(NSArray *) getPathByUser: (int)id {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *idStr = [NSString stringWithFormat:@"%d", id];
    NSString *dir = [@"getPathByUser/" stringByAppendingString:idStr];
    NSString *url = [baseURL stringByAppendingString: dir];    
    NSString *data = [request sendRequest:url withMethod:@"get" andValues:@""];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObject = [jsonParser objectWithString:data error:&error];
    NSArray *paths = [jsonObject valueForKey:@"paths"];
    return paths;

}

-(bool) addFriend: (int)id1 add:(int)id2 {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *dir = @"addFriend";
    NSString *url = [baseURL stringByAppendingString: dir];
    NSString *values = [NSString stringWithFormat:@"id1=%d&id2=%d", id1, id2];
    NSString *data = [request sendRequest:url withMethod:@"post" andValues:values];
    if ([data isEqualToString:@"1"]) 
        return TRUE;
    else 
        return FALSE;
}

-(bool) acceptFriend: (int)id1 accept:(int)id2 {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *dir = @"acceptFriend";
    NSString *url = [baseURL stringByAppendingString: dir];
    NSString *values = [NSString stringWithFormat:@"id1=%d&id2=%d", id1, id2];
    NSString *data = [request sendRequest:url withMethod:@"post" andValues:values];
    if ([data isEqualToString:@"1"]) 
        return TRUE;
    else 
        return FALSE;
}

-(bool) sharePath: (int)pathId withFriend:(int)userId {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *dir = @"sharePath";
    NSString *url = [baseURL stringByAppendingString: dir];
    NSString *values = [NSString stringWithFormat:@"pathId=%d&userId=%d", pathId, userId];
    NSString *data = [request sendRequest:url withMethod:@"post" andValues:values];
    if ([data isEqualToString:@"1"]) 
        return TRUE;
    else 
        return FALSE;

}

@end
