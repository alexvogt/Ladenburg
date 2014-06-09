//
//  ladDetailViewController.m
//  Ladenburg
//
//  Created by Tim Hartl on 17.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladDetailViewController.h"


@interface ladDetailViewController ()

{
    CGFloat draggedOffsetY;
    CGFloat previousDraggedOffsetY;
    CGFloat newImageHeight;
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



 //Test

-(void)viewWillLayoutSubviews{
    //make textView fit Text - resize container depending on text lenght
    
    /*
    [self.detailTextView sizeToFit];
    [self.detailTextView layoutIfNeeded];
    
    CGRect frame = self.detailTextView.frame;
    frame.size.height = self.detailTextView.contentSize.height;
    self.detailTextView.frame = frame;
    
    CGFloat imageViewHeight = self.detailImageView.frame.size.height;
    CGFloat contentHeight = self.detailTextView.frame.size.height;
    CGFloat contentPlusSpacer = contentHeight+imageViewHeight + 75;
    
     */
    
    //[self.detailContainerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.detailContainerView.frame), contentPlusSpacer)];
    //[self.detailScrollView setContentSize:self.detailContainerView.frame.size];

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
    
    //Turn off Bounce on Top of View
    self.detailScrollView.bounces = (self.detailScrollView.contentOffset.y > 60);
    
    draggedOffsetY = self.detailScrollView.contentOffset.y;
    
    NSLog(@"View was dragged to: %f", draggedOffsetY);
    newImageHeight = self.detailImageView.frame.size.height-draggedOffsetY;
    
    if( draggedOffsetY > previousDraggedOffsetY){
        NSLog(@"scrolling forwards");
        
            if (newImageHeight > 75  /* && newImageHeight < 150 */ ){
    
                    [UIView animateWithDuration:0.1
                            animations:^{
                                        [self.detailImageView setFrame:CGRectMake(self.detailImageView.frame.origin.x, self.detailImageView.frame.origin.y, self.detailImageView.frame.size.width, newImageHeight)];
                                        CGFloat startTop = self.detailImageView.frame.size.height;
                                        self.detailTextView.frame = CGRectMake(self.detailTextView.frame.origin.x, startTop, self.detailTextView.frame.size.width, self.detailTextView.frame.size.height);
                                        self.detailSightNameLabel.frame = CGRectMake(self.detailSightNameLabel.frame.origin.x, startTop-50, self.detailSightNameLabel.frame.size.width, self.detailSightNameLabel.frame.size.height);
                                        }
                            completion:^(BOOL finished){
                    }];
            }
    }
    /*
    else if (draggedOffsetY < previousDraggedOffsetY){
        NSLog(@"scrolling backwards");
        
        if(newImageHeight < 200){
            
                    [UIView animateWithDuration:0.1
                             animations:^{
                                 [self.detailImageView setFrame:CGRectMake(self.detailImageView.frame.origin.x, self.detailImageView.frame.origin.y, self.detailImageView.frame.size.width, newImageHeight)];
                                 CGFloat startTop = self.detailImageView.frame.size.height;
                                 self.detailTextView.frame = CGRectMake(self.detailTextView.frame.origin.x, startTop, self.detailTextView.frame.size.width, self.detailTextView.frame.size.height);
                                 self.detailSightNameLabel.frame = CGRectMake(self.detailSightNameLabel.frame.origin.x, startTop+10, self.detailSightNameLabel.frame.size.width, self.detailSightNameLabel.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
        }
    } */
    
    previousDraggedOffsetY = draggedOffsetY;

}

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    [self.detailTextView resignFirstResponder];
    if (speechPaused == NO) {
        [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.synthesizer continueSpeaking];
        speechPaused = YES;
    } else {
        [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
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
    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    speechPaused = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    speechPaused = NO;
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
