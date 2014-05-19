//
//  ladBeaconTracker.m
//  Ladenburg
//
//  Created by Sonja on 13.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

// TEST UUID 1 : A5456D78-C85B-44C6-9F20-8268FD25EF8A
// TEST MINOR: 156 - BISCHOFSHOF

#import "ladBeaconTracker.h"
#import "ladDetailViewController.h"
#import "Location.h"

@interface ladBeaconTracker ()

//Properties
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic) NSInteger *countRangedBeacon;
@property (nonatomic, strong)Location *selectedLocation;

//Utility-Methods
- (void) initRegionWithUUIDString:(NSString *)uuid andIdentifier: (NSString *)identifier;

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
    
    //[self initRegion];
    
    [self startTrackingBeacons];

    
}

- (void) startTrackingBeacons{
    //Init different regions --> change UUID in accordance with Beacons
    
    [self initRegionWithUUIDString:@"A5456D78-C85B-44C6-9F20-8268FD25EF8A" andIdentifier:@"Museum"];
    
    [self initRegionWithUUIDString:@"A5456D78-C85B-44C6-9F20-8268FD25EF8A" andIdentifier:@"Stadt"];
    
    //Debugging Log
    NSLog(@"Finished call to startTrackingBeacons");
}

- (void) initRegionWithUUIDString:(NSString *)uuid andIdentifier:(NSString *)identifier{
    
    _uuid = [[NSUUID alloc]initWithUUIDString:uuid];
    
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:_uuid identifier:identifier];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    //Debugging Log
    NSLog(@"Init Region with UUID %@ and identifier %@", _uuid , identifier);
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    //Debugging Log
    NSLog(@"Region %@ entered", _beaconRegion.identifier);
    
    _countRangedBeacon = 0;
    NSLog(@"rangedBeaconCount: %ld", (long)_countRangedBeacon);
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //[self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"Region %@ exit", _beaconRegion.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"Inside");
            self.beaconFoundLabel.text =@"Yes";
            break;
        case CLRegionStateOutside:
            NSLog(@"Outside");
            self.beaconFoundLabel.text =@"No";
            break;
        case CLRegionStateUnknown:
            NSLog(@"Unknown");
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon= [beacons lastObject];
    
    self.beaconFoundLabel.text =@"Yes";
    
    NSNumber *beaconMajor = beacon.major;
    NSNumber *beaconMinor = beacon.major;
    
    //Figure out which beacon you found
    
    NSLog(@"Ranged Beacon %@", beacon);
    
    //Implement code for notification and opening DetailView here
    
    NSLog(@"rangedBeaconCount: %ld", (long)_countRangedBeacon);
    
    if (!_countRangedBeacon) {
        
        //NSString *rangedBeaconSightName = @"Implement Name here";
        
        UIAlertView *rangedBeaconNotification = [[UIAlertView alloc] initWithTitle:@"Beacon Ranged!" message:@"You're close to a beacon, do you want to see further information to this Sight?"
            delegate:self
            cancelButtonTitle:@"No"
            otherButtonTitles:@"Yes",
            nil];
        [rangedBeaconNotification show];
    
    }
    _countRangedBeacon ++;
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AlertView Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        
        [self performSegueWithIdentifier:@"alertToDetail" sender:self];
    }
}

/*
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get reference to the destination view controller
    ladDetailViewController *ladVC = segue.destinationViewController;
    
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // toDo: SET UP _SELECTEDLOCATION
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    ladVC.selectedLocation = _selectedLocation;
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
