//
//  ladSettingsTableViewController.h
//  Ladenburg
//
//  Created by Sonja on 06.06.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ladSettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *beaconTrackingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showTutorialSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *setBackNotificationsSwitch;

- (IBAction)logo:(id)sender;



@end
