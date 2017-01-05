//
//  LocationOperations.m
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "LocationOperations.h"
@import GoogleMaps;

@implementation LocationOperations

@synthesize locationManager;

+ (id)sharedManager {
    static LocationOperations *sharedDataProcessing = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataProcessing = [[self alloc] init];
    });
    return sharedDataProcessing;
}


- (double)deviceLatitude
{
    NSLog(@"%f",locationManager.location.coordinate.latitude);
    return locationManager.location.coordinate.latitude;
}

- (double)deviceLongitude
{
    NSLog(@"%f",locationManager.location.coordinate.longitude);
    return locationManager.location.coordinate.longitude;
}

- (void)loadLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

//-(void)saveData:(RoadPath *)userPath {
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    [defaults setObject:userPath.pointName forKey:()userPath.coordinate];
//    
//    [defaults synchronize];
//    
//}

-(NSArray*)readDataFromUserDefaults {
    
    NSString *userPath = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dataDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:userPath];
    
    NSArray *allKeys =  [dataDict allKeys];
    NSArray *allValues =  [dataDict allValues];
    NSUInteger objectsCount = [allKeys count];
    
    NSMutableArray *userDataArray = [NSMutableArray new];
    
    for (int i = 0; i <objectsCount ; i++) {
        RoadPath *userPath = [RoadPath new];
        userPath.pointName = allKeys[i];
       // userPath.coordinate = allValues[i];
        
        [userDataArray addObject:userPath];
    }
    return userDataArray;
}

-(void) addMarkerPoint:(id)map withLatitude:(double)latitude andLongitude:(double)longitude andData:(RoadPath *)userPath {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude,longitude);
        marker.title = userPath.pointName;
        marker.map = map;
}


-(void)deleteDataForKey:(NSString*)key{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];

}

@end
