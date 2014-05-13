//
//  ladBeaconTracker.m
//  Ladenburg
//
//  Created by Sonja on 13.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladBeaconTracker.h"

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
    [self initRegion];
}


- (void)initRegion {
    //Check for all Beacons in Region using the following attributes
    
    // !!! CHANGE ATTRIBUTES ACCORDING TO BEACONS!!!
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"XXXXXXX"];
    NSString *regionIdentifier = @"xxx";
    
    //Init Region with the attributes defined above
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:regionIdentifier];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
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
