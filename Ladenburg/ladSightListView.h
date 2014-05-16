//
//  ladSightListView.h
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface ladSightListView : UIViewController <UITableViewDataSource, UITableViewDelegate, HomeModelProtocol>


@property (weak, nonatomic) IBOutlet UITableView *sightListView;

@end
