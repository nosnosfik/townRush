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
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyA8yTsOh930nqkpGSK2i1Ute9D9GYdM8Z8"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyCozMdZxDdO9VbouNhCj69HuidsxqEZANE"];
    return YES;
}

@end
