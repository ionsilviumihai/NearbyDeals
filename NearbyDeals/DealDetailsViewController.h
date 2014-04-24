//
//  ViewController.h
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 23/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealDetailsViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>

//interface
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//data sets
@property (strong, nonatomic) NSURL *dealURL;

@end
