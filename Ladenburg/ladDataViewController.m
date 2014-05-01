//
//  ladDataViewController.m
//  Ladenburg
//
//  Created by Alexander on 01.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladDataViewController.h"

@interface ladDataViewController ()

@end

@implementation ladDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
