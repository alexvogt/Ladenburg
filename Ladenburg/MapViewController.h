
//
//  MapViewController.h
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Sight.h"
#import "HomeModel.h"
#import <objc/runtime.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate, HomeModelProtocol, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) Sight *selectedSight;


@end
