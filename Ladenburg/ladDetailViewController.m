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
    
    //set text as hyphenated text
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.hyphenationFactor = 1;
    self.detailTextView.attributedText = [[NSMutableAttributedString alloc] initWithString:self.detailTextView.text attributes:[NSDictionary dictionaryWithObjectsAndKeys:paragraph, NSParagraphStyleAttributeName, nil]];
    
    
    // Center background image
    self.detailImageView.contentMode = UIViewContentModeCenter;
    // Scale background image to fill container
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    // Switch off clipping
    self.detailImageView.clipsToBounds = true;
    
    
    // GRADIENT CRAP
    // Set image over layer
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _detailImageView.bounds;
    
    //NSLog(@"Set up gradient");
    
    //[gradient setStartPoint:CGPointMake(0.0, 0.5)];
    //[gradient setEndPoint:CGPointMake(0.0, 0.5)];
    
    // Add colors to layer
    UIColor *endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UIColor *midLeftColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *midRightColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *startColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[startColor CGColor],
                       (id)[midLeftColor CGColor],
                       (id)[midRightColor CGColor],
                       (id)[endColor CGColor],
                       nil];
    
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:0.4],
                          [NSNumber numberWithFloat:0.7],
                          [NSNumber numberWithFloat:1],
                          nil];
    
    [_detailImageView.layer insertSublayer:gradient atIndex:1];
    
    //NSLog(@"added gradient");
    
    // END GRADIENT CRAP
    
    
    
    // Customize NavigationBar on DetailView
    
    // Set NavigationBar to invisible
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Add DropShadow to Backbutton for better readability
    UIColor *shadowColor = [UIColor blackColor];
    self.navigationController.navigationBar.layer.shadowColor = [shadowColor CGColor];
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = .8;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.5f,1.5f);
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    
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
