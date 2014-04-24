//
//  DealsTableViewController.m
//  NearbyDeals
//
//  Created by Ion Silviu-Mihai on 23/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "DealsTableViewController.h"
#import "DealsModel.h"
#import "DealDetailsViewController.h"

static NSString *kAdsSErverURL = @"http://geoadsplus.com/ads.xml";
static NSString *kAppKey = @"fe008041973b6676017";

@interface DealsTableViewController ()

@property (nonatomic, strong) NSArray *nearbyDeals;
@property (nonatomic, strong) NSMutableData *webData;

@end

@implementation DealsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDealsNearLocationForNotification:) name:[DealsModel locationUpdateNotificationName] object:];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDealsNearLocationForNotification:) name:[DealsModel locationUpdateNotificationName] object:DealsModel.sharedModel];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    CLLocationCoordinate2D deviceLocation = CLLocationCoordinate2DMake(44.25, 26.06);
    [self requestDealsNearLocation:deviceLocation limit:20];
    NSLog(@"Table view did appear");
    DealsModel *sharedModel = [DealsModel sharedModel];
    if (sharedModel.nearbyDeals == nil)
        [self requestDealsNearLocation:deviceLocation limit:20];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)nearbyDeals
{
    if(_nearbyDeals == nil)
    {
        _nearbyDeals = @[@"First Deal", @"Second Deal", @"Third Deal", @"Another Deal", @"Iphone", @"Ipad"
                         , @"Nokia", @"LG", @"Nexus5"
                         , @"Samsuns s3", @"Samsung s4", @"Samsung s5"
                         , @"Sony z2", @"HTC ONE", @"HTC ONE MAX"];
    }
    return _nearbyDeals;
}
/* setter of the nearbyDeals. If we always instantiate out Model through the setter, we make sute that the Table view always 
 knows about this change as soon as possible
 
-(void)setNearbyDeals:(NSArray *)nearbyDeals
{
    _nearbyDeals = nearbyDeals;
    [self.tableView reloadData];
}
*/

-(BOOL)requestDealsNearLocation:(CLLocationCoordinate2D)coordinate limit:(NSInteger)limit
{
    if(self.webData != nil) return NO;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?app-key=%@&latitude=%f&longitude=%f&limit=%d",
                           kAdsSErverURL,
                           kAppKey,
                           coordinate.latitude,
                           coordinate.longitude,
                           limit];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *serverConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(serverConnection != nil)
    {
        self.webData = [NSMutableData data];
        return YES;
    }
    
    return NO;
}

#pragma mark - Storyboard segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDealDetail"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        
        NSString *urlString = [NSString stringWithFormat:@"https://www.google.ro/search?q=%@&oq=%@", [self.nearbyDeals[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"+"], [self.nearbyDeals[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        NSURL *dealURL = [NSURL URLWithString:urlString];
        NSLog(@"URL built: %@",dealURL);
        
        
        DealDetailsViewController *deatailViewcontroller = (DealDetailsViewController *)segue.destinationViewController;
        deatailViewcontroller.hidesBottomBarWhenPushed = YES;
        deatailViewcontroller.dealURL = dealURL;

    }
}

#pragma mark - NSURLConnection load callbacks

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.webData = nil;
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Connection Problem"
                                                         message:@"The application was unable to connect to the server"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
    [errorAlert show];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Extract XML from webdata
    NSString *receivedXML = [[NSString alloc] initWithBytes:[self.webData mutableBytes] length:[self.webData length] encoding:NSUTF8StringEncoding];
    self.webData = nil;
    NSLog(@"Received XML: %@", receivedXML);
//    self.nearbyDeals = [SimpleXMLParser dealsArrayFromXML:receivedXML];
    
    //DealsModel *sharedModel = [DealsModel sharedModel];
    //sharedModel.nearbyDeals = [SimpleXMLParser dealsArrayFromXML:receivedXML];
    //[self.tableView reloadData];
}

-(void)requestDealsNearLocationForNotification:(NSNotification *)notification
{
    DealsModel *sharedModel = [DealsModel sharedModel];
    [self requestDealsNearLocation:sharedModel.deviceLocation.coordinate limit:20];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.nearbyDeals.count;
    
    //DealsModel *sharedModel = [DealsModel sharedModel];
    //return sharedModel.nearbyDeals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.nearbyDeals objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
