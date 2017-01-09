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
GMSMarker *carMarker;
-(void)updateLocationoordinates:(CLLocationCoordinate2D) coordinates onMap:(GMSMapView*)map
{
    
    if (carMarker == nil) {
        carMarker = [GMSMarker markerWithPosition:coordinates];
       // carMarker.icon = [UIImage imageNamed:CAR_IMAGE];
        carMarker.map = map;
    } else {

            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat: 2] forKey:kCATransactionAnimationDuration];
        
            carMarker.position = coordinates;
            GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:coordinates.latitude
                                                                     longitude:coordinates.longitude
                                                                          zoom:16];
            map.camera = camera;

            [CATransaction commit];
            
            NSLog(@"1");
    
    }
}

-(void)makeWrooomAndHustle:(NSArray *)coordsArray onMap:(GMSMapView*)map{

    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSMutableArray *fullrouteArray = [NSMutableArray new];
        for (id array in coordsArray) {
            for (CLLocation* obj in array) {
                [fullrouteArray addObject:obj];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            for (CLLocation* obj in fullrouteArray) {
                [self updateLocationoordinates:obj.coordinate onMap:map];
            }
            
        });
    });

}

@end
