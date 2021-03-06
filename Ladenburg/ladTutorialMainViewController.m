//
//  ladTutorialMainViewController.m
//  Ladenburg
//
//  Created by Sonja on 23.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladTutorialMainViewController.h"
#import "ladBeaconTracker.h"
#import "ladPageContentViewController.h"

@interface ladTutorialMainViewController ()

@end

@implementation ladTutorialMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)startWalkthrough:(id)sender {
    ladPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tutorialPageTexts = @[[NSString stringWithFormat:NSLocalizedString(@"Tutorial Page 1", nil)],
                           [NSString stringWithFormat:NSLocalizedString(@"Tutorial Page 2", nil)]
                           ];
    _tutorialPageImages = @[@"Tut_1", @"Tut_2"];
    
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    ladPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 42);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (ladPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.tutorialPageImages count] == 0) || (index >= [self.tutorialPageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ladPageContentViewController * pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    //set Content
    pageContentViewController.tutorialImageFile = self.tutorialPageImages[index];
    //pageContentViewController.tutorialTitleText = self.tutorialPageTitles[index];
    pageContentViewController.tutorialPageText = self.tutorialPageTexts[index];
    
    
    //set Image to AspectFill
    pageContentViewController.tutorialImageView.contentMode = UIViewContentModeCenter;
    pageContentViewController.tutorialImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    //set pageIndex
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.tutorialPageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ladPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ladPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.tutorialPageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

// Set Statusbarcolor to white
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


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