//
//  ladBeaconTracker.h
//  Ladenburg
//
//  Created by Sonja on 13.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "HomeModel.h"
#import "Location.h"

@interface ladBeaconTracker : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate, HomeModelProtocol>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (strong, nonatomic) Location *selectedSight;

@property (nonatomic, strong) NSMutableDictionary *sightsDict;

 - (void) startTrackingBeacons;

@end
