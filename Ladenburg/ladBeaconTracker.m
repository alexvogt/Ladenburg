//
//  ladBeaconTracker.m
//  Ladenburg
//
//  Created by Sonja on 13.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

// TEST UUID 1 : A5456D78-C85B-44C6-9F20-8268FD25EF8A
// TEST MINORS: 156 - BISCHOFSHOF ( "Cocktail Mint" )
//              97 - BURGUS ("Icy Marshmallow")
//              163 - CARL-BENZ-HAUS ("Blueberry Pie")

#import "ladBeaconTracker.h"
#import "ladDetailViewController.h"
#import "Sight.h"

@interface ladBeaconTracker ()

{
    CLBeacon *lastBeacon;
    NSMutableDictionary *shownBeacons;
    NSString *beaconIdentifierKey;
};

//Properties
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic) NSInteger *countRangedBeacon;
@property (nonatomic) HomeModel *homeModel;
@property (nonatomic, strong)CLBeacon *beacon;
@property (nonatomic, strong)CLBeacon *nearestBeacon;
@property (nonatomic, strong)CLBeacon *lastIdentifiedBeacon;


//Utility-Methods
- (void) startTrackingBeacons;
- (void) initRegionWithUUIDString:(NSString *)uuid andIdentifier: (NSString *)identifier;
- (void) identifyDetectedBeacon: (CLBeacon *)beacon;
- (void) sendNotification;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create dictionary object and assign it to _sightsDict variable
    _sightsDict = [[NSMutableDictionary alloc] init];
    
    // Create new HomeModel object and assign it to _homeModel variable
    _homeModel = [[HomeModel alloc] init];
    
    // Set this view controller object as the delegate for the home model object
    _homeModel.delegate = self;
    
    // Call the download items method of the home model object
    [_homeModel downloadItems];
    
    [self startTrackingBeacons];
    shownBeacons = [[NSMutableDictionary alloc] init];
    
}

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    for (Sight* currentSight in items)
    {
        [_sightsDict setObject:currentSight forKey:currentSight.identifier];
    }
    
}

- (void) startTrackingBeacons{
    //Init different regions --> change UUID in accordance with Beacons
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }
    
    else {
        [self initRegionWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" andIdentifier:@"Stadt"];
        [self initRegionWithUUIDString:@"A5456D78-C85B-44C6-9F20-8268FD25EF8A" andIdentifier:@"Museum"];
    }
    
    //Debugging Log
    NSLog(@"Finished call to startTrackingBeacons");
}

- (void) initRegionWithUUIDString:(NSString *)uuid andIdentifier:(NSString *)identifier{
    
    _uuid = [[NSUUID alloc]initWithUUIDString:uuid];
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:_uuid identifier:identifier];
    
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
        //Debugging Log
        NSLog(@"Init Region with UUID %@ and identifier %@", _uuid , identifier);
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    //Debugging Log
    NSLog(@"Region %@ entered", _beaconRegion.identifier);
    
    _countRangedBeacon = 0;
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
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
    //_beacon = [[CLBeacon alloc] init];
    _nearestBeacon = [[CLBeacon alloc]init];

     beacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity != %d", CLProximityUnknown]];
    _nearestBeacon = [beacons firstObject];
    
    // Figure out which beacon you found
    if(_nearestBeacon.minor == NULL || _nearestBeacon.major == NULL){
        //Do nothing. This is just used for debugging
    }
    
    else{
        
        beaconIdentifierKey = [NSString stringWithFormat:@"%@-%@-%@", [_nearestBeacon.proximityUUID UUIDString], [_nearestBeacon.major stringValue], [_nearestBeacon.minor stringValue]];

        [self identifyDetectedBeacon:_nearestBeacon];
        
    }
}

- (void)identifyDetectedBeacon:beacon{
    
        self.beaconFoundLabel.text =@"Yes";
    
        NSNumber *beaconMinor = _nearestBeacon.minor;
        NSLog(@"beaconMinor: %@", beaconMinor);
        NSString *beaconMinorString = [beaconMinor stringValue];
    
    
        if ([shownBeacons objectForKey:beaconIdentifierKey]){
            
            NSLog(@"Beacon was shown already");
        }
    
        else if (![shownBeacons objectForKey:beaconIdentifierKey]) {
            
            NSLog(@"Beacon not shown. Add to dict.");
            
            [shownBeacons setObject:_nearestBeacon forKey:beaconIdentifierKey];
            
            //Figure out which beacon was found by attributing Minor to Object-ID
            if ([_sightsDict objectForKey:beaconMinorString]) {
                
                _selectedSight=[_sightsDict objectForKey:beaconMinorString];
                NSLog(@"Selected Sight ist %@", _selectedSight.name);

                [self sendNotification];
                
            } else {
                NSLog(@"No object set for key @\"b\"");
            }
        }
}

- (void)sendNotification {
    
    //if (!_countRangedBeacon) {
        
        //Send Alert
        NSString *beaconAlertTitle = _selectedSight.name;
        NSString *message = [NSString stringWithFormat:@"You're close to the '%@', do you want to see further information to this Sight?", _selectedSight.name];
        
        UIAlertView *rangedBeaconAlert = [[UIAlertView alloc] initWithTitle:beaconAlertTitle message:message
                                                                          delegate:self
                                                                 cancelButtonTitle:@"No"
                                                                 otherButtonTitles:@"Yes",
                                                 nil];
        [rangedBeaconAlert show];
      
        //Send Notification
        UILocalNotification *rangedBeaconNotification = [[UILocalNotification alloc] init];
        rangedBeaconNotification.alertAction = @"View";
        rangedBeaconNotification.alertBody = message;
        rangedBeaconNotification.fireDate = nil;
        rangedBeaconNotification.applicationIconBadgeNumber ++;
        [[UIApplication sharedApplication] scheduleLocalNotification:rangedBeaconNotification];
        
   /* }
    _countRangedBeacon ++; */
}

//Make sure notifications are only shown when App is running in the background

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
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
    
    //If View is cancelled go back to ranging beacons
    else
    {
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
}


#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get reference to the destination view controller
    ladDetailViewController *ladVC = segue.destinationViewController;
    
    
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
