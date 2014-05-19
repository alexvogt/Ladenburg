//
//  ladDetailViewController.h
//  Ladenburg
//
//  Created by Tim Hartl on 17.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface ladDetailViewController : UIViewController

@property (strong, nonatomic) Location *selectedLocation;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailSightNameLabel;


@end
