//
//  LocationOperations.m
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "LocationOperations.h"

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

@end
