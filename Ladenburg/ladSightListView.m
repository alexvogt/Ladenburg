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
#import <objc/runtime.h>


@interface ladSightListView ()
{
    HomeModel *_homeModel;
    NSMutableArray *_sightsFeedItems;
    NSMutableArray *_exhibitsFeedItems;
    NSMutableArray *_selectedFeed;
    
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
    
    //Hide Navigation Bar
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Remove Separator between each Cell
    [self.sightListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Set this view controller object as the delegate and data source for the table view
    self.sightListView.delegate = self;
    self.sightListView.dataSource = self;
    
    // Create array object and assign it to _feedItems variable
    _sightsFeedItems = [[NSMutableArray alloc] init];
    _exhibitsFeedItems = [[NSMutableArray alloc] init];
    _selectedFeed = [[NSMutableArray alloc] init];
    
    if(self.listSegmentedControl.selectedSegmentIndex == 0){
        _selectedFeed = _sightsFeedItems;
    } else if (self.listSegmentedControl.selectedSegmentIndex == 1){
        _selectedFeed = _exhibitsFeedItems;
    }
    [_sightListView reloadData];
    
    // Create new HomeModel object and assign it to _homeModel variable
    _homeModel = [[HomeModel alloc] init];
    
    // Set this view controller object as the delegate for the home model object
    _homeModel.delegate = self;
    
    // Call the download items method of the home model object
    [_homeModel downloadItems];
    
    // Set Statusbarcolor to white
    [self setNeedsStatusBarAppearanceUpdate];

    // Create the locationManager

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = 5; // whenever we move 5m
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    self.location = [[CLLocation alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.location = locations.lastObject;
    //NSLog(@"%@", self.location.description);
    
    [self.locationManager stopUpdatingLocation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(_turnOnLocationManager)  userInfo:nil repeats:NO];
    
    [_sightListView reloadData];
}

- (void)_turnOnLocationManager {
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    
    /* COMMENTED OUT JUST FOR EVENT!!!
     
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    */
    NSLog(@"Error: %@",error.description);
}

-(void)sightsDownloaded:(NSArray *)sights
{
    NSLog(@"Sights downloaded called");
    // This delegate method will get called when the items are finished downloading
    // Set the downloaded items to the array
    
    for(int i=0; i < [sights count]; i++ ){
        [_sightsFeedItems addObject:sights[i]];
    }
    
    // Reload the table view
    [self.sightListView reloadData];
}

-(void)exhibitsDownloaded:(NSArray *)exhibitsArray
{
    NSLog(@" downloaded called");
    
    for(int i=0; i < [exhibitsArray count]; i++ ){
        [_exhibitsFeedItems addObject:exhibitsArray[i]];
    }
    
    // Reload the table view
    [self.sightListView reloadData];
}

- (IBAction)segmentedControlSelected:(id)sender{
    
    if(self.listSegmentedControl.selectedSegmentIndex == 0){
        _selectedFeed = _sightsFeedItems;
    } else if (self.listSegmentedControl.selectedSegmentIndex == 1){
        _selectedFeed = _exhibitsFeedItems;
    }
    
    [_sightListView reloadData];
}

#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if(self.listSegmentedControl.selectedSegmentIndex == 0){
        // Return the number of feed items (initially 0)
        _selectedFeed = _sightsFeedItems;
    } else if (self.listSegmentedControl.selectedSegmentIndex == 1){
        _selectedFeed = _exhibitsFeedItems;
    }*/
    
    return _selectedFeed.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set height of each TableCell to 100px (= 200px for Retina)
    // IF HEIGHT OF TABLE CELL IS CHANGED, ALSO CHANGE GRADIENT-LAYER SIZE
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
    Sight *item = _selectedFeed[indexPath.row];
    
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
    
    if ([item.major isEqual:@"1337"]){
        [myCell.detailTextLabel setText:@"Lobdengau-Museum"];
    } else {
        [myCell.detailTextLabel setText:[df stringFromDistance: meters]];
    }
    
    
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
    
    // Disable cellhilighting for tapping.
    [myCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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
    // Switch on clipping
    bgView.clipsToBounds = true;
    
    // GRADIENT CRAP
    // Set image over layer
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //gradient.frame = myCell.frame;
    gradient.frame = CGRectMake(0, 0, 320, 100);
    
    [gradient setStartPoint:CGPointMake(0.0, 0.5)];
    [gradient setEndPoint:CGPointMake(1.0, 0.5)];
    
    // Add colors to layer
    UIColor *endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    UIColor *midLeftColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIColor *midRightColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UIColor *startColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[startColor CGColor],
                       (id)[midLeftColor CGColor],
                       (id)[midRightColor CGColor],
                       (id)[endColor CGColor],
                       nil];
    
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:0.8],
                          [NSNumber numberWithFloat:1],
                          nil];
    
    [myCell.backgroundView.layer insertSublayer:gradient atIndex:1];
    
    // END GRADIENT CRAP
    
    [myCell setBackgroundView:bgView];
    //[myCell setSelectedBackgroundView:bgView];
    
    [myCell.backgroundView.layer insertSublayer:gradient atIndex:1];

    
    return myCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected sight to var
    _selectedSight = _selectedFeed[indexPath.row];
    
    // Manually call segue to detail view controller
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

// Set Statusbarcolor to white
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
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

#pragma mark AlertView Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        _selectedSight = objc_getAssociatedObject(alertView, &MyConstantKey);
        NSLog(@"DetailView called from List, Selected Sight is: %@", _selectedSight.name);
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
    }
    
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
