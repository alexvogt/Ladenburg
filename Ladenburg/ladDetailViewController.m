//
//  ladDetailViewController.m
//  Ladenburg
//
//  Created by Tim Hartl on 17.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladDetailViewController.h"


@interface ladDetailViewController ()

@property NSString *baseURL;
@property NSString *originalImageURL;
@property NSString *shortenedImageURL;
@property NSString *fullURL;
@property NSURL *url;
@property UIImage *selectedSightImage;



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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _baseURL = @"http://ladenburg.timhartl.de";
    //Debugging Log
    NSLog(@"%@",_baseURL);

    _originalImageURL = _selectedLocation.imageUrl;
    _shortenedImageURL = [_originalImageURL substringFromIndex:2];
    
    _fullURL = [_baseURL stringByAppendingString:_shortenedImageURL];
    
    //Debugging Log
    NSLog(@"%@", _fullURL);
    
    _url = [NSURL URLWithString:_fullURL];
    NSData *data = [NSData dataWithContentsOfURL:_url];
    
    _selectedSightImage = [[UIImage alloc] initWithData:data];
    
    
    self.detailImageView.image = _selectedSightImage;
    self.detailTextView.text = _selectedLocation.text;
    self.detailSightNameLabel.text = _selectedLocation.name;
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
