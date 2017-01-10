//
//  AppDelegate.m
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate () 

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyBeSANhZsSY0m1_FduOziNY2AU_-g_oMTg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyCRbcmzLKuf7go1XpLa4rAnYGE0uJ3p8DQ"];
    return YES;
}

@end
