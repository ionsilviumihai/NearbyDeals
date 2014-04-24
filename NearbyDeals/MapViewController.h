//
//  MapViewController.h
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 24/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(void)addDealAnnotationForNotification:(NSNotification *)notification;

-(void)showMapRegionForNotification:(NSNotification *)notification;


@end
