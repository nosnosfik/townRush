//
//  RoadPath.m
//  townRush
//
//  Created by Nikita Taranov on 1/4/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "RoadPath.h"

@implementation RoadPath

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.coordinates = _coordinates;
        self.pointName = _pointName;
        self.pointID = _pointID;
    }
    return self;
}



@end
