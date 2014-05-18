//
//  ladBeaconTracker.m
//  Ladenburg
//
//  Created by Sonja on 13.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

// TEST UUID 1 : A5456D78-C85B-44C6-9F20-8268FD25EF8A

#import "ladBeaconTracker.h"

@interface ladBeaconTracker ()

//Properties
@property NSUUID *uuid;

//Utility-Methods
//- (void) initRegionWithUUIDString:(NSString *)uuid andIdentifier: (NSString *)identifier;

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
    
   // [self startTrackingBeacons];

    
}


- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A5456D78-C85B-44C6-9F20-8268FD25EF8A"];
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:@"Museum"];
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    //Debugging Logging
    NSLog(@"Region %@ initated", _beaconRegion.identifier);
}

/*
- (void) startTrackingBeacons{
    //Init different regions --> change UUID in accordance with Beacons
    
    [self initRegionWithUUIDString:@"A5456D78-C85B-44C6-9F20-8268FD25EF8A" andIdentifier:@"Museum"];
    
    [self initRegionWithUUIDString:@"A5456D78-C85B-44C6-9F20-8268FD25EF8A" andIdentifier:@"Stadt"];
    
    
}

- (void) initRegionWithUUIDString:(NSString *)uuid andIdentifier:(NSString *)identifier{
    
    _uuid = [[NSUUID alloc]initWithUUIDString:uuid];
    
    //Debugging Log
    NSLog(@"UUID: %@", _uuid);
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:_uuid identifier:identifier];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
}
 
 */

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    //Debugging Logging
    NSLog(@"Region %@ entered", _beaconRegion.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"Region %@ exit", _beaconRegion.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon= [beacons lastObject];
    
    
    self.beaconFoundLabel.text =@"Yes";
    
    NSLog(@"Ranged Region %@", _beaconRegion.identifier );
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
