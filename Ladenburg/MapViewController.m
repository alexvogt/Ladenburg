//
//  MapViewController.m
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "MapViewController.h"
#import "ladSightListView.h"
#import "Sight.h"
#import "ladDetailViewController.h"
#import "ladBeaconTracker.h"

@interface MapViewController (){
    
    HomeModel *homeModel;
    MapViewController *mapVC;
    
    NSArray *_sightArray;
    NSMutableArray *annotationMuArr;
    
}

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
    
    //self.navigationController.navigationBar.translucent = NO;
    
    self.mapView.delegate = self;
    
    ////////////////////
    
    // Create array object and assign it to _feedItems variable
    _sightArray = [[NSArray alloc] init];
    
    // Create new HomeModel object and assign it to _homeModel variable
    homeModel = [[HomeModel alloc] init];
    
    // Set this view controller object as the delegate for the home model object
    homeModel.delegate = self;
    
    // Call the download items method of the home model object
    [homeModel downloadItems];
    
    
    self.mapView.showsPointsOfInterest = NO;
    
}

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    
    // test = [ladSightListView sortDownloadedArray:items];
    //NSLog(@"ficker");
    _sightArray = items;
    annotationMuArr = [[NSMutableArray alloc] init];
    
    NSUInteger count = [_sightArray count];
    
    // NSLog(@"Count %lU",count);
    
    for (int x = 0; x<count; x++) {
        
        Sight *item = _sightArray[x];
        
        //NSLog(@"Count: %lU Name: %@",(unsigned long)count,item.name);
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        [point setCoordinate:CLLocationCoordinate2DMake([item.latitude doubleValue], [item.longitude doubleValue])];
        [point setTitle:item.name];
        
        [_mapView addAnnotation:point];
        
        [annotationMuArr addObject:point];
        
    }
    
    //[mapVC showSightsOnMap];
    //NSLog(@"Bitch1: %lu",(unsigned long)count);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //Hide NavigatonBar
    [self.navigationController setNavigationBarHidden:YES];
    
    //1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 49.473976;
    zoomLocation.longitude= 8.607746;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 700, 700);
    [self.mapView setRegion:viewRegion animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -MapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    MKAnnotationView * annotationView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
    if (!annotationView)
    {
        
        NSInteger index = [self->annotationMuArr indexOfObject:annotation];
        
        NSUInteger indexRight = index;
        
        _selectedSight = _sightArray[indexRight];
        
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        annotationView.image = [UIImage imageNamed:@"map_annotation_pin.png"];
        
        //annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }else {
        annotationView.annotation = annotation;
    }
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:_selectedSight.image];
    myImageView.frame = CGRectMake(0,0,31,31);
    
    annotationView.leftCalloutAccessoryView = myImageView;
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Set selected sight to var
    
    NSInteger index = [self->annotationMuArr indexOfObject:view.annotation];

    NSUInteger indexRight = index;
    
    _selectedSight = _sightArray[indexRight];
    
    //NSLog(@"calloutAccessoryControlTapped: annotation = %@ Index: %lu", view.annotation,(unsigned long)index);
    
    // Manually call segue to detail view controller
    [self performSegueWithIdentifier:@"DetailViewMap" sender:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    // Set Statusbarcolor to white
    return UIStatusBarStyleLightContent;
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"DetailViewMap"]) {
        
        // Get reference to the destination view controller
        ladDetailViewController *ladVC = segue.destinationViewController;
        
        // Set the property to the selected sight so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        ladVC.selectedSight = _selectedSight;
    }
}

#pragma mark AlertView Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        _selectedSight = objc_getAssociatedObject(alertView, &MyConstantKey);
        NSLog(@"DetailView called from List, Selected Sight is: %@", _selectedSight.name);
        [self performSegueWithIdentifier:@"DetailViewMap" sender:self];
    }
    
}


@end

