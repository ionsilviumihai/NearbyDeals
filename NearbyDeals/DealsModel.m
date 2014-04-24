//
//  DealsModel.m
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 24/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "DealsModel.h"

@implementation DealsModel

@synthesize deviceLocation = _deviceLocation;



+(DealsModel *)sharedModel
{
    static DealsModel *sharedModel;
    if (sharedModel == nil) {
        sharedModel = [[DealsModel alloc] init];
    }
    return sharedModel;
}

-(CLLocation *) deviceLocation //getter
{
    if (_deviceLocation == nil) {
        _deviceLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    }
    return _deviceLocation;
}



-(void)setDeviceLocation:(CLLocation *)deviceLocation
{
    _deviceLocation = deviceLocation;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[DealsModel locationUpdateNotificationName] object:self];
}

+(NSString *)locationUpdateNotificationName
{
    return @"locationUpdateNotification";
}



+(NSString *)dealsUpdateNotificationName
{
    return @"dealsUpdateNotification";
}

-(void)setNearbyDeals:(NSArray *)nearbyDeals //setter
{
    _nearbyDeals = nearbyDeals;
    [[NSNotificationCenter defaultCenter] postNotificationName:[DealsModel dealsUpdateNotificationName] object:self];
    //we have to know when a nearby deals have loaded. The map view is going to be a observer og the sharedModel to receive notification. Upon receiving this notification, it will add annotations on its map view
}


@end
