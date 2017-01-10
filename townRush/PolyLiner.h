//
//  PolyLiner.h
//  townRush
//
//  Created by Nikita Taranov on 1/5/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoadPath.h"
@import GoogleMaps;


@interface PolyLiner : NSObject

- (void)getDataFromServerWithData:(NSArray*)data completion:(void (^)(id JSON))completion failure:(void (^)(NSError * error))failure;
-(void) drawPolylineOnMap:(GMSMapView*)map andData:(NSDictionary*)data;
-(NSArray*) getCoordsFromEncodedData:(NSDictionary*)data;
-(void) buildAWay:(NSArray*)array onMap:(GMSMapView*)map;

@end
