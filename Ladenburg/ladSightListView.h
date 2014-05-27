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

@interface ladSightListView : UIViewController <UITableViewDataSource, UITableViewDelegate, HomeModelProtocol, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sightListView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) NSTimer *timer;


@end