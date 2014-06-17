//
//  ladSightListView.h
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HomeModel.h"
#import <QuartzCore/QuartzCore.h>
#import "Sight.h"
#import "ladBeaconTracker.h"

@interface ladSightListView : UIViewController <UITableViewDataSource, UITableViewDelegate, HomeModelProtocol, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sightListView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UISegmentedControl *listSegmentedControl;


- (IBAction)segmentedControlSelected:(id)sender;

@end