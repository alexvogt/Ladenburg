//
//  ladDetailViewController.h
//  Ladenburg
//
//  Created by Tim Hartl on 17.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sight.h"
#import <AVFoundation/AVFoundation.h>

@interface ladDetailViewController : UIViewController <UIScrollViewDelegate, AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) Sight *selectedSight;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailSightNameLabel;

@property (strong, nonatomic) IBOutlet UIView *detailMainView;

@property (weak, nonatomic) IBOutlet UIView *detailContainerView;

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;


//Constraints
/*
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImageViewHeightConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTextViewHeightConstraint;
*/

// Synthesizer
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end
