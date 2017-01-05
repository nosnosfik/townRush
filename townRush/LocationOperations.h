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

@interface LocationOperations : NSObject <CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager *locationManager;


+ (id)sharedManager;
- (double)deviceLatitude;
- (double)deviceLongitude;
- (void)loadLocationManager;
- (void) saveData:(RoadPath*)userPath;
- (NSDictionary*) readDataFromUserDefaults;
- (void)deleteDataForKey:(NSString*)key;


@end
