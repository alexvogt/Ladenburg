//
//  ladAboutViewController.m
//  Ladenburg
//
//  Created by Sonja on 07.06.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladAboutViewController.h"

@interface ladAboutViewController ()

{
    CGFloat draggedOffsetY;
    CGFloat previousDraggedOffsetY;
    CGFloat newImageHeight;
}

@end

@implementation ladAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)openLink:(UIButton *)sender forURL:(NSURL *)url{
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    
};


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.aboutScrollView.delegate = self;
    [self.aboutScrollView setContentSize:self.aboutContainerView.frame.size];
    
    //Debugging Log
    //NSLog(@"ContentHeight: %e", self.detailScrollView.contentSize.height);
    
    //Inset Content so white bar on top isn't shown
    UIEdgeInsets inset = UIEdgeInsetsMake(-65, 0, 0, 0) ;
    [self.aboutScrollView setContentInset:inset];
    
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.aboutText.text = NSLocalizedString(@"About Text", nil);
    
    //set text as hyphenated text and add linespacing.
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.hyphenationFactor = 1;
    //    paragraph.minimumLineHeight = 23.4;
    paragraph.lineSpacing = 1.6;
    self.aboutText.attributedText = [[NSMutableAttributedString alloc] initWithString:self.aboutText.text attributes:[NSDictionary dictionaryWithObjectsAndKeys:paragraph, NSParagraphStyleAttributeName, nil]];
    
    // Set Fontsize of Content to 18px = 36px retina.
    [_aboutText setFont:[UIFont systemFontOfSize:18.0]];
    
    // Center background image
    self.aboutImageView.contentMode = UIViewContentModeCenter;
    // Scale background image to fill container
    self.aboutImageView.contentMode = UIViewContentModeScaleAspectFill;
    // Switch off clipping
    self.aboutImageView.clipsToBounds = true;
    
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //Turn off Bounce on Top of View
    self.aboutScrollView.bounces = (self.aboutScrollView.contentOffset.y > 60);
    
    draggedOffsetY = self.aboutScrollView.contentOffset.y;
    
    NSLog(@"View was dragged to: %f", draggedOffsetY);
    newImageHeight = self.aboutImageView.frame.size.height-draggedOffsetY;
    
    if( draggedOffsetY > previousDraggedOffsetY){
        NSLog(@"scrolling forwards");
        
        if (newImageHeight > 75  /* && newImageHeight < 150 */ ){
            
            [UIView animateWithDuration:0.1
                             animations:^{
                                 [self.aboutImageView setFrame:CGRectMake(self.aboutImageView.frame.origin.x, self.aboutImageView.frame.origin.y, self.aboutImageView.frame.size.width, newImageHeight)];
                                 CGFloat startTop = self.aboutImageView.frame.size.height;
                                 self.aboutText.frame = CGRectMake(self.aboutText.frame.origin.x, startTop, self.aboutText.frame.size.width, self.aboutText.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
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
