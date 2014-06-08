//
//  ladAboutViewController.h
//  Ladenburg
//
//  Created by Sonja on 07.06.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ladAboutViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *aboutMainView;

@property (weak, nonatomic) IBOutlet UIScrollView *aboutScrollView;

@property (weak, nonatomic) IBOutlet UIView *aboutContainerView;

@property (weak, nonatomic) IBOutlet UITextView *aboutText;
@property (weak, nonatomic) IBOutlet UIImageView *aboutImageView;


@end
