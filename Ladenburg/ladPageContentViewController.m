//
//  ladPageContentViewController.m
//  Ladenburg
//
//  Created by Sonja on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladPageContentViewController.h"

@interface ladPageContentViewController ()

@end

@implementation ladPageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // uncomment once image is implemented
    // self.backgroundImageView.image = [UIImage imageNamed:self.tutorialImageFile];
    
    self.tutorialTitleLabel.text = self.tutorialTitleText;
    
    self.tutorialTextView.text = self.tutorialPageText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
