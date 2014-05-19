//
//  ladDetailViewController.h
//  Ladenburg
//
//  Created by Tim Hartl on 17.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sight.h"

@interface ladDetailViewController : UIViewController

@property (strong, nonatomic) Sight *selectedSight;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailSightNameLabel;


@end
