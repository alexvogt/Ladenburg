//
//  ladBeaconTracker.m
//  Ladenburg
//
//  Created by Sonja on 13.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladBeaconTracker.h"
#import "ladBeacon.h"

@interface ladBeaconTracker ()


@end

@implementation ladBeaconTracker

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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    ladBeacon *beaconForum = [[ladBeacon alloc] initWithUUID:@"LADENBURG" andMajor:1 andMinor:1 andIdentifier:@"ladenburg"];
    ladBeacon *beaconMuseum = [[ladBeacon alloc] initWithUUID:@"LADENBURG" andMajor:2 andMinor:12 andIdentifier:@"lobdengaumuseum"];
    
    NSMutableArray *beacons = [NSMutableArray arrayWithObjects:(id)beaconForum, (id)beaconMuseum, nil];
    
    NSLog(@"Beacon 1 is %@", beacons[0]);
    NSLog(@"Beacon 2 is %@", beacons[1]);
    
    
    [self initRegions];
}


- (void)initRegions {
    //Check for all Beacons in Region using the following attributes
    
    //needed: Array for different Majors (since these define the regions)
    //for (
    
    // !!! CHANGE ATTRIBUTES ACCORDING TO BEACONS!!!
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"LADENBURG"];
    NSString *regionIdentifier = @"xxx";
    
    //Init Region with the attributes defined above
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:regionIdentifier];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    [self.beaconRegions addObject:_beaconRegion];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon= [beacons lastObject];
    
    //Do something
    //e.g. change labels depending on beacon properties etc.
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

@end
