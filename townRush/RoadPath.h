//
//  RoadPath.h
//  townRush
//
//  Created by Nikita Taranov on 1/4/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RoadPath : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, copy) NSString *pointName;
@property (nonatomic, copy) NSString *pointID;

@end
