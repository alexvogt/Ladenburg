//
//  ladDetailViewController.m
//  Ladenburg
//
//  Created by Tim Hartl on 17.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladDetailViewController.h"


@interface ladDetailViewController ()

@end

@implementation ladDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.detailImageView.image = _selectedSight.image;
    self.detailTextView.text = _selectedSight.kurzbeschreibung;
    self.detailSightNameLabel.text = _selectedSight.name;
    
    // Center background image
    self.detailImageView.contentMode = UIViewContentModeCenter;
    // Scale background image to fill container
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    // Switch off clipping
    self.detailImageView.clipsToBounds = true;
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
