//
//  DealsTableViewController.h
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 23/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DealsTableViewController : UITableViewController <NSURLConnectionDataDelegate>

-(BOOL)requestDealsNearLocation:(CLLocationCoordinate2D)coordinate
                          limit:(NSInteger)limit;

-(void)requestDealsNearLocationForNotification:(NSNotification *)notification;

@end
