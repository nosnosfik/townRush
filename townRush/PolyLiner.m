//
//  PolyLiner.m
//  townRush
//
//  Created by Nikita Taranov on 1/5/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "PolyLiner.h"
#import "AFNetworking.h"
#import "RoadPath.h"

static NSString *apiKey = @"AIzaSyCozMdZxDdO9VbouNhCj69HuidsxqEZANE";

@implementation PolyLiner

- (void)getDataFromServerWithData:(NSArray*)data completion:(void (^)(id JSON))completion failure:(void (^)(NSError * error))failure {
    
    NSArray *pointsData =  data;
    NSString *pointID = [NSString new];

    NSMutableArray *userDataArray = [NSMutableArray new];
    
    for (RoadPath *userData in pointsData) {
        if(userData != (id)[NSNull null]){
            pointID = userData.pointID;
            [userDataArray addObject:pointID];
        }
    }
    NSUInteger objectsCount = [userDataArray count];

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=place_id:%@&destination=place_id:%@&key=%@",userDataArray[0],userDataArray[objectsCount-1],apiKey];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            completion(responseObject);
        }
    }];
    [dataTask resume];
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
