//
//  ladTutorialMainViewController.h
//  Ladenburg
//
//  Created by Sonja on 23.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ladTutorialMainViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *tutorialPageTitles;
@property (strong, nonatomic) NSArray *tutorialPageTexts;

@property (strong, nonatomic) NSArray *tutorialPageImages;

@end
