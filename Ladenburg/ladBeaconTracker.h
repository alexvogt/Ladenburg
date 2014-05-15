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

@interface ladBeaconTracker : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion; //used the individual regions the app is supposed to look for
@property (strong, nonatomic) CLLocationManager *locationManager; //used  for handling location-related activities

@property (strong) NSMutableArray* beaconRegions; //collection of the different regions
@end
