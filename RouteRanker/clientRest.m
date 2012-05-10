//
//  clientRest.m
//  Calculator
//
//  Created by Eric Denovitzer on 4/28/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import "clientRest.h"



@implementation clientRest
NSString const * 
baseURL = @"http://ec2-177-71-143-149.sa-east-1.compute.amazonaws.com:8080/";

#define CC_MD5_DIGEST_LENGTH 16 

- (NSString *)md5:(NSString *)str { 
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH]; 
    CC_MD5(cStr, strlen(cStr), result); 
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",                     
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];        
}


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

-(bool) sharePath: (int)pathId fromUser:(int)creator withFriend:(int)userId {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *dir = @"sharePath";
    NSString *url = [baseURL stringByAppendingString: dir];
    NSString *shareId = [NSString stringWithFormat:@"%da%d", creator, pathId];
    NSString *values = [NSString stringWithFormat:@"pathId=%@&userId=%d", shareId, userId];
    NSString *data = [request sendRequest:url withMethod:@"post" andValues:values];
    if ([data isEqualToString:@"1"]) 
        return TRUE;
    else 
        return FALSE;

}

-(bool) addPath:(Route *)path withId:(int)idPath ofUser:(int)id {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *dir = @"addPath";
    NSString *url = [baseURL stringByAppendingString: dir];
    
    //Get all variables
    MKMapPoint *points = path.points;
    NSUInteger numPoints = path.numPoints;
    NSMutableArray *times = path.timeArray;
    NSString *distance = [[NSNumber numberWithDouble:[path getTotalDistanceTraveled]] stringValue];
    NSMutableArray *annotations = path.annotations;
    NSUInteger numAnnotations = path.numAnnotations;
    NSString *name = path.name;
    NSString *totalTime = [[NSNumber numberWithDouble:[path getTotalTimeElapsed]] stringValue];

    //Format
    //Points
    NSString *pointsFormat = [[NSString alloc] init];
    for(int i = 0; i < numPoints; i++) {
        pointsFormat =  [pointsFormat stringByAppendingString: 
                         [NSString stringWithFormat:@"%f,%f#", points[i].x, points[i].y]];
        
    }
    
    //Times
    NSString *timesFormat = [[NSString alloc] init];
    for (int i = 0; i < numPoints; i++) {
        NSDate *current = [times objectAtIndex:i];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *formattedDateString = [dateFormatter stringFromDate:current];
        timesFormat = [timesFormat stringByAppendingString:formattedDateString];
        timesFormat = [timesFormat stringByAppendingString:@"#"];
    }
    
    //Annotations
    
    NSString *annotationsFormat = [[NSString alloc] init];
    if (numAnnotations > 0) {
        for (int i = 0; i < numAnnotations; i++) {
            RouteAnnotation *current = [annotations objectAtIndex:i];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            NSString *formattedDateString = [dateFormatter stringFromDate:current.time];
            
            annotationsFormat = [NSString stringWithFormat:@"%s,%s,%s,%f,%f#",
                                 formattedDateString, current.title, current.subtitle,
                                 current.coordinate.latitude, current.coordinate.longitude]; 
        }
    }
    else 
        annotationsFormat = @"NULL";
    
    NSString *values =  [NSString stringWithFormat:
                         @"idPath=%d&userId=%d&name=%@&points=%@&times=%@&distance=%@&numPoints=%d&numAnnotations=%d&annotations=%@&totalTime=%@",
                         idPath, id, name, pointsFormat,timesFormat,distance, numPoints,
                         numAnnotations, annotationsFormat, totalTime];
    
    NSString *data = [request sendRequest:url withMethod:@"post" andValues:values];
    
    if (data == @"0") 
        return TRUE;
    else 
        return FALSE;
   }

-(void)getPathWithId: (int)pathId ofUser: (int)userId {
    URLRequest *request = [[URLRequest alloc] init];
    NSString *idStr = [NSString stringWithFormat:@"%da%d", userId, pathId];
    NSString *dir = [@"get/paths/" stringByAppendingString:idStr];
    NSString *url = [baseURL stringByAppendingString: dir];
    NSString *data = [request sendRequest:url withMethod:@"get" andValues:@""];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObject = [jsonParser objectWithString:data error:&error];
    
    //Get raw values
    NSString *name = [jsonObject valueForKey:@"pathName"];
    int numPoints = [[jsonObject valueForKey:@"numPoints"] intValue];
    NSString *points = [jsonObject valueForKey:@"points"];
    NSString *times = [jsonObject valueForKey:@"times"];
    int numAnnotations = [[jsonObject valueForKey:@"numAnnotations"] intValue];
    NSString *annotations = [jsonObject valueForKey:@"annotations"];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];   
    double distance = [[jsonObject valueForKey:@"distance"] doubleValue];
    double totalTime = [[jsonObject valueForKey:@"totalTime"] doubleValue];
    
    //Core data
    RouteData *routeData = [NSEntityDescription insertNewObjectForEntityForName:@"RouteData" inManagedObjectContext:context];
    routeData.title = name;
    routeData.owner = [NSNumber numberWithInt: userId];
    routeData.idNo = [NSNumber numberWithInt:pathId];
    routeData.distance = [NSNumber numberWithDouble:distance];
    routeData.numAnnotations = [NSNumber numberWithInt: numAnnotations];
    routeData.numPoints = [NSNumber numberWithInt: numPoints];
    routeData.time = [NSNumber numberWithInt:totalTime];
    
    //Points
    NSMutableArray *mapPoints = [NSMutableArray arrayWithCapacity:numPoints];
    NSArray *pointsArrayString = [points componentsSeparatedByString:@"#"];
    NSArray *timesArrayString = [times componentsSeparatedByString:@"#"];
    for (int i=0; i<numPoints; i++) {
        MapPointData *mapPoint = [NSEntityDescription insertNewObjectForEntityForName:@"MapPointData" inManagedObjectContext:context];
        NSArray *coord =[[pointsArrayString objectAtIndex:i] componentsSeparatedByString:@","];
        double x = [[coord objectAtIndex:0] doubleValue];
        double y = [[coord objectAtIndex:1] doubleValue];
        NSString *currentTime = [timesArrayString objectAtIndex:i];
        
        //Format NSDate
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSDate *currentDate = [dateFormatter dateFromString:currentTime];
        
        mapPoint.sequence = [NSNumber numberWithInt: i];
        mapPoint.timestamp = currentDate;
        mapPoint.x = [NSNumber numberWithDouble:x];
        mapPoint.y = [NSNumber numberWithDouble:y];
        mapPoint.route = routeData;
        [mapPoints addObject:mapPoint];
    }
    
    routeData.annotations = nil;
        
    NSError *errorSave;
    if (![context save:&errorSave]) {
        NSLog(@"Whoops, couldn't save: %@", [errorSave localizedDescription]);
    }
    else {
        NSLog(@"YEAH");
    }
   
}

@end
