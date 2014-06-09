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
#import "Sight.h"

@interface ladBeaconTracker : UIViewController <CLLocationManagerDelegate, UIApplicationDelegate, UIAlertViewDelegate, HomeModelProtocol, CBCentralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSMutableArray *beaconRegions;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (strong, nonatomic) Sight *selectedSight;

@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (nonatomic, strong) NSMutableDictionary *sightsDict;

@end
