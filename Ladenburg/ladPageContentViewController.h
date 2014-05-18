//
//  ladPageContentViewController.h
//  Ladenburg
//
//  Created by Sonja on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ladPageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tutorialTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tutorialTextView;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property NSUInteger pageIndex;

@property NSString *tutorialTitleText;
@property NSString *tutorialPageText;


// later on implement background image
// add outlet for image and uncomment the following
// @property NSString *tutorialImageFile;

@end
