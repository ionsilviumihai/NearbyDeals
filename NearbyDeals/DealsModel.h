//
//  DealsModel.h
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 24/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DealsModel : NSObject

@property (nonatomic, strong) NSArray *nearbyDeals;
@property (nonatomic, strong) CLLocation *deviceLocation;

+(DealsModel *)sharedModel;


+ (NSString *)locationUpdateNotificationName;

+ (NSString *)dealsUpdateNotificationName;

@end
