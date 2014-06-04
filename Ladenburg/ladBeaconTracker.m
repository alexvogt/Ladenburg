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
    
    //Variables for Notification Timout
    NSMutableDictionary *shownBeacons;
    NSString *beaconIdentifierKey;
    NSTimeInterval timeInSecUntilNextNotification;
    
    //Animation Outlets
    __weak IBOutlet UIImageView *outerAnimationView;
    __weak IBOutlet UIImageView *innerAnimationView;
    __weak IBOutlet UIImageView *middleAnimationView;
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
- (void) startAnimationForView;

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
    
    // Pulsating scan-animation starts
    [self startAnimationForView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set Application BAdge to 0
    //delet once pushed
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
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
    
    //Alloc and init Dictionaries to track Notifications
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
        
        //Inform user that device can't use beacon functionality
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:@"This device can't be used as an iBeacon Receiver" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }
    else {
        //Initalize Beacon Regions for inside and outside of museum
        [self initRegionWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" andIdentifier:@"Stadt"];
        [self initRegionWithUUIDString:@"A5456D78-C85B-44C6-9F20-8268FD25EF8A" andIdentifier:@"Museum"];
    }
}

- (void) initRegionWithUUIDString:(NSString *)uuid andIdentifier:(NSString *)identifier{
    
    _uuid = [[NSUUID alloc]initWithUUIDString:uuid];
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:_uuid identifier:identifier];
    
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
        //Debugging Log
        //NSLog(@"Init Region with UUID %@ and identifier %@", _uuid , identifier);
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    //Debugging Log
   // NSLog(@"Region %@ entered", _beaconRegion.identifier);
    
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
    
    //Find the first (closest) beacon in Array
    _nearestBeacon = [[CLBeacon alloc]init];
     beacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity != %d", CLProximityUnknown]];
    _nearestBeacon = [beacons firstObject];
    
    // Figure out which sight that beacon corresponds with
    if(_nearestBeacon.minor == NULL || _nearestBeacon.major == NULL){
        //Do nothing. This is just used for debugging
    }
    else{
        //set an identifierKey and call identifyDetectedBeacon to figure out corresponding sight
        beaconIdentifierKey = [NSString stringWithFormat:@"%@-%@-%@", [_nearestBeacon.proximityUUID UUIDString], [_nearestBeacon.major stringValue], [_nearestBeacon.minor stringValue]];
        [self identifyDetectedBeacon:_nearestBeacon];
    }
}

- (void)identifyDetectedBeacon:beacon{
    
        self.beaconFoundLabel.text =@"Yes";
    
        NSNumber *beaconMinor = _nearestBeacon.minor;
        NSLog(@"beaconMinor: %@", beaconMinor);
        NSString *beaconMinorString = [beaconMinor stringValue];

        //Variables for time out
        NSDate *now = [[NSDate alloc] init];
        timeInSecUntilNextNotification = 900; //15Min * 60 Sec = 900 sec

    
        if ([shownBeacons objectForKey:beaconIdentifierKey]){
            
            NSLog(@"Beacon was shown already");
            
            //Check when beacon was last seen and compare to 30 min in seconds
            NSDate *lastSeen = [shownBeacons objectForKey:beaconIdentifierKey];
            NSTimeInterval secondsSinceLastSeen = [now timeIntervalSinceDate:lastSeen];
            NSLog(@"This beacon was last notified about at %@: %.0f seconds ago", lastSeen, secondsSinceLastSeen);
            
            //If Beacon hasn't been seen in a certain time interval
            if (secondsSinceLastSeen > timeInSecUntilNextNotification)
            {
                
                _selectedSight=[_sightsDict objectForKey:beaconMinorString];
                NSLog(@"Selected Sight ist %@", _selectedSight.name);
                
                //set new time for this object in beaconShown array
                [shownBeacons setObject:now forKey:beaconIdentifierKey];
                
                [self sendNotification];
            }
        }
    
        else if (![shownBeacons objectForKey:beaconIdentifierKey]) {
            
            NSLog(@"Beacon not shown. Add to dict.");
            
            //set time for this object in beaconShown array
            [shownBeacons setObject:now forKey:beaconIdentifierKey];
            
            //Figure out which beacon was found by attributing Minor to Object-ID
            if ([_sightsDict objectForKey:beaconMinorString]) {
                
                _selectedSight=[_sightsDict objectForKey:beaconMinorString];
                
                //set time for this object in beaconShown array
                //[shownBeacons setObject:now forKey:beaconMinorString];

                
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



-(void) startAnimationForView{
    //// Declaring first image view -> point
    UIImage *image = [UIImage imageNamed: @"first-scan.png"];
    [innerAnimationView setImage:image];
    CALayer *scanIcon = [CALayer layer];
    [self.view.layer addSublayer:scanIcon];
    [innerAnimationView setAlpha:0];
    
    // pulse animation with 1 delay
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.beginTime = CACurrentMediaTime()+1;
    theAnimation.duration=1.3;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
    theAnimation.toValue=[NSNumber numberWithFloat:1.0];
    [innerAnimationView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
    
    //// Declaring second image view -> middle ring
    UIImage *image2 = [UIImage imageNamed: @"second-scan.png"];
    [middleAnimationView setImage:image2];
    CALayer *scanIcon2 = [CALayer layer];
    [self.view.layer addSublayer:scanIcon2];
    [middleAnimationView setAlpha:0];
    
    // pulse animation with 1.5 delay
    CABasicAnimation *theAnimation2;
    theAnimation2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation2.beginTime = CACurrentMediaTime()+1.5;
    theAnimation2.duration=1.3;
    theAnimation2.repeatCount=HUGE_VALF;
    theAnimation2.autoreverses=YES;
    theAnimation2.fromValue=[NSNumber numberWithFloat:0.0];
    theAnimation2.toValue=[NSNumber numberWithFloat:1.0];
    [middleAnimationView.layer addAnimation:theAnimation2 forKey:@"animateOpacity"];
    
    //// Declaring third image view -> outer ring
    UIImage *image3 = [UIImage imageNamed: @"third-scan.png"];
    [outerAnimationView setImage:image3];
    CALayer *scanIcon3 = [CALayer layer];
    [self.view.layer addSublayer:scanIcon3];
    [outerAnimationView setAlpha:0];
    
    // pulse animation with 1.8 delay
    CABasicAnimation *theAnimation3;
    theAnimation3=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation3.beginTime = CACurrentMediaTime()+1.8;
    theAnimation3.duration=1.3;
    theAnimation3.repeatCount=HUGE_VALF;
    theAnimation3.autoreverses=YES;
    theAnimation3.fromValue=[NSNumber numberWithFloat:0.0];
    theAnimation3.toValue=[NSNumber numberWithFloat:1.0];
    [outerAnimationView.layer addAnimation:theAnimation3 forKey:@"animateOpacity"];
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
