//
//  LocationOperations.h
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RoadPath.h"
@import GoogleMaps;

@interface LocationOperations : NSObject <CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(atomic, assign) BOOL flagComplete;

+ (id)sharedManager;
- (double)deviceLatitude;
- (double)deviceLongitude;
- (void)loadLocationManager;
-(void) addMarkerPoint:(id)map andData:(RoadPath *)userPath;
-(void)makeWrooomAndHustle:(NSArray*)coordsArray onMap:(GMSMapView *)map;


@end
