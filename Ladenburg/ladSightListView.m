//
//  ladSightListView.m
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladSightListView.h"
#import "Sight.h"
#import "MapViewController.h"
#import "ladDetailViewController.h"

@interface ladSightListView ()
{
    HomeModel *_homeModel;
    NSArray *_feedItems;
    Sight *_selectedSight;
}

@end

@implementation ladSightListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Remove Separator between each Cell
    [self.sightListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Set this view controller object as the delegate and data source for the table view
    self.sightListView.delegate = self;
    self.sightListView.dataSource = self;
    
    // Create array object and assign it to _feedItems variable
    _feedItems = [[NSArray alloc] init];
    
    // Create new HomeModel object and assign it to _homeModel variable
    _homeModel = [[HomeModel alloc] init];
    
    // Set this view controller object as the delegate for the home model object
    _homeModel.delegate = self;
    
    // Call the download items method of the home model object
    [_homeModel downloadItems];
    

    // Create the locationManager

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = 5; // whenever we move 5m
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    self.locationManager.delegate = self;
    self.location = [[CLLocation alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.location = locations.lastObject;
    NSLog(@"%@", self.location.description);
    
    [self.locationManager stopUpdatingLocation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(_turnOnLocationManager)  userInfo:nil repeats:NO];
}

- (void)_turnOnLocationManager {
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    _feedItems = items;
    
    // Reload the table view
    [self.sightListView reloadData];
}

#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of feed items (initially 0)
    return _feedItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set height of each TableCell to 100px (= 200px for Retina)
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve cell
    NSString *cellIdentifier = @"SightCell";
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Create detail Label for each Cell
    myCell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellIdentifier];
    

    
    // Get the sight to be shown
    Sight *item = _feedItems[indexPath.row];
    
    // Get references to labels of cell
    myCell.textLabel.text = item.name;
    
        //DebugVersion - Label with Identifier.
        //myCell.textLabel.text = [item.name stringByAppendingString:item.identifier];
    
    // Changing color to White and set Fontsize
    myCell.textLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    myCell.textLabel.font = [UIFont systemFontOfSize:24.0];    

    // Adding dropshadow to Text
    UIColor *shadowColor = [UIColor blackColor];
    myCell.textLabel.layer.shadowColor = [shadowColor CGColor];
    myCell.textLabel.layer.shadowRadius = 2.0f;
    myCell.textLabel.layer.shadowOpacity = .8;
    myCell.textLabel.layer.shadowOffset = CGSizeMake(1.5f,1.5f);
    myCell.textLabel.layer.masksToBounds = NO;
    

    
    /*
    
    // TESTAREA - CONVERSION OF STRING TO DOUBLE
    
    //    NSLog(@"%@",jsonElement[@"LOC_LATITUDE"]);
    NSLog(@"String: %@",item.latitude);
    
    double testValue = [item.latitude doubleValue];
    NSLog(@"Double: %f",testValue);
   */
    
    
    // Determining Location of the Cell/Sight
    double testLatitude = [item.latitude doubleValue];
    double testLongitude = [item.longitude doubleValue];
    CLLocation *sightLoc = [[CLLocation alloc] initWithLatitude:testLatitude longitude:testLongitude];

    
    // Determining user Location
    CLLocation *currentLoc = self.location;
    // Calculating distance to Sight
    CLLocationDistance meters = [sightLoc distanceFromLocation:currentLoc];

    // Get references to detaillabels of cell
    //[myCell.detailTextLabel setText:[[NSString stringWithFormat:@"%.0lf", meters] stringByAppendingString:@"m"]];
    
    MKDistanceFormatter *df = [[MKDistanceFormatter alloc]init];
    df.unitStyle = MKDistanceFormatterUnitStyleAbbreviated;
    
    
    [myCell.detailTextLabel setText:[df stringFromDistance: meters]];
    
    // Changing color to White and set Fontsize
    [myCell.detailTextLabel setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]];
    [myCell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    // Adding dropshadow to detailText
    myCell.detailTextLabel.layer.shadowColor = [shadowColor CGColor];
    myCell.detailTextLabel.layer.shadowRadius = 2.0f;
    myCell.detailTextLabel.layer.shadowOpacity = .8;
    myCell.detailTextLabel.layer.shadowOffset = CGSizeMake(1.5f,1.5f);
    myCell.detailTextLabel.layer.masksToBounds = NO;

    // Get background image for each Cell
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:myCell.backgroundView.frame];
    [bgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    
    // Lots of crazy Filterstuff to get Black & White images in Listview!
    CIImage *ciImage = [[CIImage alloc] initWithImage:item.image];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"
                                 keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    
    bgView.image = [UIImage imageWithCGImage:cgImage];
    
    // Original Image - without BW Filter on top.
    //bgView.image = item.image;
    
    // Center background image
    bgView.contentMode = UIViewContentModeCenter;
    // Scale background image to fill container
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    // Switch off clipping
    bgView.clipsToBounds = true;
    
    [myCell setBackgroundView:bgView];
    
    return myCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected sight to var
    _selectedSight = _feedItems[indexPath.row];
    
    // Manually call segue to detail view controller
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get reference to the destination view controller
    ladDetailViewController *ladVC = segue.destinationViewController;
    
    // Set the property to the selected sight so when the view for
    // detail view controller loads, it can access that property to get the feeditem obj
    ladVC.selectedSight = _selectedSight;
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

@end
