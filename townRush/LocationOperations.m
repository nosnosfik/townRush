//
//  LocationOperations.m
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "LocationOperations.h"
#import <QuartzCore/QuartzCore.h>


@implementation LocationOperations

GMSMarker *carMarker;
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

-(void) addMarkerPoint:(id)map andData:(RoadPath *)userPath {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = userPath.coordinates;
        marker.title = userPath.pointName;
        marker.map = map;
}

-(void)updateLocationoordinates:(CLLocationCoordinate2D) coordinates onMap:(GMSMapView*)map
{
  
    if (carMarker == nil) {
        carMarker = [GMSMarker markerWithPosition:coordinates];
        carMarker.icon = [UIImage imageNamed:@"taxi"];
        carMarker.map = map;
        
    } else {

        [CATransaction begin];
        
        [CATransaction setAnimationDuration:0.005f];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:coordinates.latitude
                                                                     longitude:coordinates.longitude
                                                                          zoom:16];
            map.camera = camera;
        });
        
        GMSCameraUpdate *vancouverCam = [GMSCameraUpdate setTarget:coordinates];
        [map animateWithCameraUpdate:vancouverCam];
        carMarker.position = coordinates;
        
    }

        [CATransaction commit];
    
    

}

-(void)makeWrooomAndHustle:(NSArray *)coordsArray onMap:(GMSMapView*)map{


        NSMutableArray *fullrouteArray = [NSMutableArray new];
        for (id array in coordsArray) {
            for (CLLocation* obj in array) {
                [fullrouteArray addObject:obj];
            }
        }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
    dispatch_async(queue, ^{
       for (CLLocation* obj in fullrouteArray) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateLocationoordinates:obj.coordinate onMap:map];
           [NSThread sleepForTimeInterval:0.01f];
        });
       }
    });

}

@end
