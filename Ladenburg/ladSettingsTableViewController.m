//
//  ladSettingsTableViewController.m
//  Ladenburg
//
//  Created by Sonja on 06.06.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladSettingsTableViewController.h"
#import <objc/runtime.h>
#import "Sight.h"
#import "ladBeaconTracker.h"
#import "ladDetailViewController.h"

@interface ladSettingsTableViewController ()

@end

@implementation ladSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set Switches according to UserDefaults from SettingsApp
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTutorial"]){
        [_showTutorialSwitch setOn:YES animated:YES];
    }else{
        [_showTutorialSwitch setOn:NO animated:YES];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableBeaconTracking"]){
        [_beaconTrackingSwitch setOn:YES animated:YES];
    }else{
        [_beaconTrackingSwitch setOn:NO animated:YES];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"setBackNotifications"]){
        [_setBackNotificationsSwitch setOn:YES animated:YES];
    }else{
        [_setBackNotificationsSwitch setOn:NO animated:YES];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}


//Methods to set Settings on User Interaction
- (IBAction)changeTutorialSettings:(id)sender {
    if ([_showTutorialSwitch isOn]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTutorial"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTutorial"];
    }
    
    //Debugging Log
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"set showTutorial to %@", [[NSUserDefaults standardUserDefaults] boolForKey:@"showTutorial"] ? @"YES" : @"NO");
}

- (IBAction)changeBeaconSettings:(id)sender {
    if ([_beaconTrackingSwitch isOn]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enableBeaconTracking"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"enableBeaconTracking"];
    }
    
    //Debugging Log
    NSLog(@"set beaconTracking to %@", [[NSUserDefaults standardUserDefaults] boolForKey:@"enableBeaconTracking"] ? @"YES" : @"NO");
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)setBackNotifications:(id)sender {
    
    if ([_setBackNotificationsSwitch isOn]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"setBackNotifications"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"setBackNotifications"];
    }
    
    //Debugging Log
    NSLog(@"set back Notifications to %@", [[NSUserDefaults standardUserDefaults] boolForKey:@"setBackNotifications"] ? @"YES" : @"NO");
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        Sight *_selectedSight = objc_getAssociatedObject(alertView, &sightAlertConstantKey);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        ladDetailViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:@"ladDetailViewController"];
        destinationVC.selectedSight=_selectedSight;
        [self.navigationController pushViewController:destinationVC animated:YES];
    }
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
} */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
