//
//  ViewController.m
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 23/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "DealDetailsViewController.h"


@interface DealDetailsViewController ()

@end

@implementation DealDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    
    //clear web view previuos content
    [self.webView
     stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.dealURL];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebView delegate methods

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Loading problem" message:@"The application was unable to load the request" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [errorAlert show];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

#pragma marh - UiAlergView delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
