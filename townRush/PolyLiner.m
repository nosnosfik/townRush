//
//  PolyLiner.m
//  townRush
//
//  Created by Nikita Taranov on 1/5/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "PolyLiner.h"
#import "AFNetworking.h"

static NSString *apiKey = @"AIzaSyCRbcmzLKuf7go1XpLa4rAnYGE0uJ3p8DQ";

@implementation PolyLiner

- (void)getDataFromServerWithData:(NSArray*)data completion:(void (^)(id JSON))completion failure:(void (^)(NSError * error))failure {
    
    NSArray *pointsData =  data;
    NSString *pointID = [NSString new];

    NSMutableArray *userDataArray = [NSMutableArray new];
    NSMutableArray *userWaypointDataArray = [NSMutableArray new];
    NSString *waypointString = [NSString new];
    
    for (RoadPath *userData in pointsData) {
        if(userData != (id)[NSNull null]){
            pointID = userData.pointID;
            [userDataArray addObject:[NSString stringWithFormat:@"place_id:%@",pointID]];
        }
    }
    
    NSUInteger objectsCount = [userDataArray count];
  
    for (int i=0; i<objectsCount; i++) {
        if (!((userDataArray[i] == userDataArray[0]) || (userDataArray[i] == userDataArray[objectsCount-1]))) {
            [userWaypointDataArray addObject:userDataArray[i]];
        }
    }
    
    waypointString = [userWaypointDataArray componentsJoinedByString:@"|"];
    
    if (objectsCount>1) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&waypoints=optimize:false|%@&key=%@",userDataArray[0],userDataArray[objectsCount-1],waypointString,apiKey];
        
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:set]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            completion(responseObject);
        }
    }];
    [dataTask resume];
    }
}

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    const char *bytes = [encodedStr UTF8String];
    NSUInteger length = [encodedStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];

    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:finalLat longitude:finalLon];
        [array addObject:location];

    }

    return array;
}


-(NSArray*) getCoordsFromEncodedData:(NSDictionary*)data{
    NSArray *route = [NSArray new];
    NSMutableArray *coordsArray = [NSMutableArray new];
    route = [data valueForKeyPath:@"routes.legs.steps.polyline.points"];
    
    for (id array in route) {
        for (id obj in array) {
            for (id locString in obj) {
                [coordsArray addObject:[self decodePolyLine:locString]];
               
            }
        }
    }
    
    return coordsArray;
}

-(void) drawPolylineOnMap:(GMSMapView*)map andData:(NSDictionary*)data{

    NSArray *route = [NSArray new];
    route = [data valueForKeyPath:@"routes.legs.steps.polyline.points"];
    
                for (id array in route) {
                    for (id obj in array) {
                        for (id locString in obj) {
                            GMSPolyline *rectangle = [GMSPolyline polylineWithPath:[GMSPath pathFromEncodedPath:locString]];
                            rectangle.map = map;
                        }
                    }
                }

}


@end
