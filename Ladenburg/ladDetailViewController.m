//
//  ladDetailViewController.m
//  Ladenburg
//
//  Created by Tim Hartl on 17.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladDetailViewController.h"
#import <objc/runtime.h>

@interface ladDetailViewController ()

{
    CGFloat draggedOffsetY;
    CGFloat previousDraggedOffsetY;
    CGFloat newImageHeight;
    CGFloat minImageHeight;
    CGFloat maxImageHeight;
    CGFloat newWidth;

}

@end

@implementation ladDetailViewController

// Synthesizer
BOOL speechPaused = 0;

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
    
    self.detailScrollView.delegate = self;
    
    
    [self.detailScrollView setContentSize:self.detailContainerView.frame.size];
    
    //Debugging Log
    //NSLog(@"ContentHeight: %e", self.detailScrollView.contentSize.height);
    
    //Inset Content so white bar on top isn't shown
    UIEdgeInsets inset = UIEdgeInsetsMake(-65, 0, 0, 0) ;
    [self.detailScrollView setContentInset:inset];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Make one String out of the different texts for sight
    NSString *kurzbeschreibung = [_selectedSight kurzbeschreibung];
    NSString *absatz = @"\n\n";
    NSString *geschichte = [_selectedSight geschichte];
    NSString *kurzbeschreibungAbsatz = [kurzbeschreibung stringByAppendingString:absatz];
    NSString *text = [kurzbeschreibungAbsatz stringByAppendingString:geschichte];
    
    self.detailImageView.image = _selectedSight.image;
    //self.detailTextView.text = _selectedSight.kurzbeschreibung;
    self.detailTextView.text = text;
    self.detailSightNameLabel.text = _selectedSight.name;
    
    // Set Fontsize of Content to 27px = 54px retina.
    self.detailSightNameLabel.font = [UIFont systemFontOfSize:27.0];
    
    //set text as hyphenated text and add linespacing.
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.hyphenationFactor = 1;
//    paragraph.minimumLineHeight = 23.4;
    paragraph.lineSpacing = 1.6;
    self.detailTextView.attributedText = [[NSMutableAttributedString alloc] initWithString:self.detailTextView.text attributes:[NSDictionary dictionaryWithObjectsAndKeys:paragraph, NSParagraphStyleAttributeName, nil]];
    
    // Set Fontsize of Content to 18px = 36px retina.
    [_detailTextView setFont:[UIFont systemFontOfSize:18.0]];
    [_detailTextView setTextAlignment:NSTextAlignmentJustified];
    //self.detailTextView.textAlignment = NSTextAlignmentJustified;
    
    
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
    
    // Synthesizer
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    speechPaused = NO;
    self.synthesizer.delegate = self;
    
}

//Change Layout on scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    draggedOffsetY = self.detailScrollView.contentOffset.y;
    
    NSLog(@"View was dragged to: %f", draggedOffsetY);
    newImageHeight = self.detailImageView.frame.size.height-draggedOffsetY;
    minImageHeight = 115;
    maxImageHeight = 220;
    
    //Check if scrolling forwards or backwards
    if( draggedOffsetY > previousDraggedOffsetY){
        //scrolling forwards
            if (newImageHeight > minImageHeight){
    
                    [UIView animateWithDuration:0.1
                            animations:^{
                                        [self.detailImageView setFrame:CGRectMake(self.detailImageView.frame.origin.x, self.detailImageView.frame.origin.y, self.detailImageView.frame.size.width, newImageHeight)];
                                        CGFloat textStartTop = self.detailImageView.frame.size.height;
                                        self.detailTextView.frame = CGRectMake(self.detailTextView.frame.origin.x, textStartTop, self.detailTextView.frame.size.width, self.detailTextView.frame.size.height);
                                
                                        if((textStartTop-45) > 90){
                                            self.detailSightNameLabel.frame = CGRectMake(self.detailSightNameLabel.frame.origin.x, textStartTop-45, self.detailSightNameLabel.frame.size.width, self.detailSightNameLabel.frame.size.height);
                                        }else{
                                            [self.detailSightNameLabel setFrame:CGRectMake(self.detailSightNameLabel.frame.origin.x, (0+draggedOffsetY+75), self.detailSightNameLabel.frame.size.width, self.detailSightNameLabel.frame.size.height)];
                                        }
                                        }
                            completion:^(BOOL finished){
                    }];
        }else if (newImageHeight < minImageHeight){
            
                                     [self.detailImageView setFrame:CGRectMake(0, (0+draggedOffsetY), self.detailImageView.frame.size.width, minImageHeight)];
                                     [self.detailSightNameLabel setFrame:CGRectMake(self.detailSightNameLabel.frame.origin.x, (0+draggedOffsetY+75), self.detailSightNameLabel.frame.size.width, self.detailSightNameLabel.frame.size.height)];
            }
    }
    else if (draggedOffsetY <= previousDraggedOffsetY){
        
        //Turn off Bounce on Top of View
        self.detailScrollView.bounces = (self.detailScrollView.contentOffset.y > 60);
        
        //scrolling backwards
        NSLog(@"scrolling backwards");

        if(draggedOffsetY > 0){
        
                [self.detailImageView setFrame:CGRectMake(0, (0+draggedOffsetY), self.detailImageView.frame.size.width, minImageHeight)];
                [self.detailSightNameLabel setFrame:CGRectMake(self.detailSightNameLabel.frame.origin.x, (0+draggedOffsetY+75), self.detailSightNameLabel.frame.size.width, self.detailSightNameLabel.frame.size.height)];
        /*
        
        }else if( draggedOffsetY <0){
                if(newImageHeight < maxImageHeight){
                    
                    [UIView animateWithDuration:0.1
                                     animations:^{
            
                                         [self.detailImageView setFrame:CGRectMake(self.detailImageView.frame.origin.x, self.detailImageView.frame.origin.y, self.detailImageView.frame.size.width, newImageHeight)];
                                         
                                     }
                    completion:^(BOOL finished){
                    }];
            
                }else if((newImageHeight > maxImageHeight)){
            
                        [self.detailImageView setFrame:CGRectMake(0, (0+draggedOffsetY), self.detailImageView.frame.size.width, maxImageHeight)];
                        self.detailScrollView.bounces = (self.detailScrollView.contentOffset.y > 60);
                    
                    }
                }
        
        }else{
                
                [self.detailImageView setFrame:CGRectMake(0, (0+draggedOffsetY), self.detailImageView.frame.size.width, maxImageHeight)];
                self.detailScrollView.bounces = (self.detailScrollView.contentOffset.y > 60);
    */ }
    }
    previousDraggedOffsetY = draggedOffsetY;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}

-(void) viewWillDisappear:(BOOL)animated {
    self.detailScrollView.delegate = nil;
    self.detailScrollView.scrollEnabled = NO;
    self.detailScrollView.scrollEnabled = YES;
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    [super viewWillDisappear:animated];
}

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    [self.detailTextView resignFirstResponder];
    
    UIImage * buttonImagePlay = [UIImage imageNamed:@"Play_icons"];
    UIImage * buttonImagePause = [UIImage imageNamed:@"Pause_icons"];
    
    if (speechPaused == NO) {
        //[self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.playPauseButton setImage:buttonImagePause forState:UIControlStateNormal];
        [self.synthesizer continueSpeaking];
        speechPaused = YES;
    } else {
        [self.playPauseButton setImage:buttonImagePlay forState:UIControlStateNormal];
        speechPaused = NO;
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    if (self.synthesizer.speaking == NO) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.detailTextView.text];
        utterance.rate = AVSpeechUtteranceMaximumSpeechRate/3;
        utterance.pitchMultiplier = 1.2; // [0.5 - 2] Default = 1
        //utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-au"];
        [self.synthesizer speakUtterance:utterance];
    }
    
}

// Set Statusbarcolor to white
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    UIImage * buttonImagePlay1 = [UIImage imageNamed:@"Play_icons"];
    [self.playPauseButton setImage:buttonImagePlay1 forState:UIControlStateNormal];
    speechPaused = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    UIImage * buttonImagePlay2 = [UIImage imageNamed:@"Play_icons"];
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self.playPauseButton setImage:buttonImagePlay2 forState:UIControlStateNormal];
    speechPaused = NO;
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
        _selectedSight = objc_getAssociatedObject(alertView, &MyConstantKey);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        ladDetailViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:@"ladDetailViewController"];
        destinationVC.selectedSight=_selectedSight;
        [self.navigationController pushViewController:destinationVC animated:YES];
    }
}

/*
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get reference to the destination view controller
    
    NSLog(@"DetailView called from Home, Selected Sight is: %@", _selectedSight.name);
    ladDetailViewController *ladVC = segue.destinationViewController;
    
    
    ladVC.selectedSight = _selectedSight;
}*/


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
