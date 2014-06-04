//
//  ladAppDelegate.m
//  Ladenburg
//
//  Created by Alexander on 01.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladAppDelegate.h"

@implementation ladAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Make sure the page index dots fit the background color
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    // Set the application setting defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *appDefaults = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], @"enableBeaconTracking",
                                 [NSNumber numberWithBool:YES], @"showTutorial",
                                 nil];
    
    [defaults registerDefaults:appDefaults];
    
    [defaults synchronize];
    
    //DEBUGGING:
    //Check if Settings have been changed
    BOOL beaconTrackingEnabled = [defaults boolForKey:@"enableBeaconTracking"];
    BOOL showTutorialEnabled = [defaults boolForKey:@"showTutorial"];
    NSLog(@"set beaconTracking to %@", beaconTrackingEnabled ? @"YES" : @"NO");
    NSLog(@"set showTutorial to %@", showTutorialEnabled ? @"YES" : @"NO");
    
    
    //Show Tutorial on first View only
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    NSLog(@"set showTutorial to %@", showTutorialEnabled ? @"YES" : @"NO");
    
    if([defaults boolForKey:@"showTutorial"]){
        NSLog(@"showTutorial");
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ladTutorialMainViewController"];
        self.window.rootViewController = viewController;
        
        [defaults setBool:NO forKey:@"showTutorial"];
        
    } else {
        NSLog(@"Don't showTutorial");
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ladMainTabController"];
        self.window.rootViewController = viewController;
    }
    
    [defaults synchronize];
    
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
