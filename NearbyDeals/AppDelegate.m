//
//  AppDelegate.m
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 23/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "AppDelegate.h"
#import "DealsModel.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = 10;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.locationManager stopUpdatingLocation];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Application did enter background");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.locationManager startUpdatingLocation];
    NSLog(@"Application did became active");
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CLLocation delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DealsModel *sharedModel = [DealsModel sharedModel];
    if (sharedModel.deviceLocation.coordinate.latitude == 0.0 && sharedModel.deviceLocation.coordinate.longitude == 0.0) {
        sharedModel.deviceLocation = newLocation;
    }
    NSLog(@"Location: %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"Distance: %f", [sharedModel.deviceLocation distanceFromLocation:newLocation]);
    if ([sharedModel.deviceLocation distanceFromLocation:newLocation] > 100) {
        sharedModel.deviceLocation = newLocation;
    }
    NSLog(@"1 Device location %f - %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

/*
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"2 Device location %u - %u", locations.count - 1, locations.count - 2);
}
*/

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Please activate location Services" message:@"The app needs your device location" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorAlert show];
    }
}

@end
