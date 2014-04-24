//
//  MapViewController.m
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 24/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "MapViewController.h"
#import "DealsModel.h"
#import "DealAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDealAnnotationForNotification:) name:[DealsModel dealsUpdateNotificationName] object:[DealsModel sharedModel]];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMapRegionForNotification:) name:[DealsModel locationUpdateNotificationName] object:[DealsModel sharedModel]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addDealAnnotationForNotification:(NSNotification *)notification
{
    [self.mapView removeAnnotation:self.mapView.annotations];
    
    DealsModel *sharedModel = [DealsModel sharedModel];
    
    for (NSDictionary *dealInfo in sharedModel.nearbyDeals)
    {
        NSString *title = [dealInfo objectForKey:@"title"];
        CLLocationDegrees latitute = [[dealInfo objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude = [[dealInfo objectForKey:@"longitute"] doubleValue];
        
        DealAnnotation *annotation = [[DealAnnotation alloc] init];
        annotation.title = title;
        annotation.coordinate = CLLocationCoordinate2DMake(latitute, longitude);
        [self.mapView addAnnotation:annotation];
    }
    
}

-(void)showMapRegionForNotification:(NSNotification *)notification
{
    DealsModel *sharedModel = [DealsModel sharedModel];
    
    CLLocationCoordinate2D coordinate = sharedModel.deviceLocation.coordinate;
    MKCoordinateRegion visibilRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
    [self.mapView setRegion:visibilRegion animated:!self.view.hidden];
}


@end
