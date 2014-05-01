//
//  ladModelController.h
//  Ladenburg
//
//  Created by Alexander on 01.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ladDataViewController;

@interface ladModelController : NSObject <UIPageViewControllerDataSource>

- (ladDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(ladDataViewController *)viewController;

@end
