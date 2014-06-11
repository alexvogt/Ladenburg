//
//  HomeModel.m
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "HomeModel.h"
#import "Sight.h"

@interface HomeModel()
{
    NSMutableData *_downloadedData;
    NSString *baseURL;
    NSString *shortenedImageURL;
    NSString *fullURL;
    NSURL *url;
    
    NSURL *jsonFileUrl;
    
}
@end

@implementation HomeModel

- (void)downloadItems
{
    //Check for Language Settings
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    
    if([currentLanguage isEqualToString:@"de"]){

    
        // Download german json file
        // jsonFileUrl = [NSURL URLWithString:@"http://m-ladenburg.de/service-lb-de.php"];
        
        // Lokale Installation
        //jsonFileUrl = [NSURL URLWithString:@"http://localhost:8888/ladenburg/service-lb-de.php"];
       
        // Locale Nework Installation
        // Replace URL with IP of Network Server
        //jsonFileUrl = [NSURL URLWithString:@"http://192.168.100.100:8888/ladenburg/service-lb-de.php"];
        
        
        // Huawei
        jsonFileUrl = [NSURL URLWithString:@"http://192.168.1.150:8888/ladenburg/service-lb-de.php"];
        
        
    } else {
        
        // Download german json file
        //jsonFileUrl = [NSURL URLWithString:@"http://m-ladenburg.de/service-lb-en.php"];
        
        // Lokale Installation
        //jsonFileUrl = [NSURL URLWithString:@"http://localhost:8888/ladenburg/service-lb-en.php"];
        
        // Locale Nework Installation
        // Replace URL with IP of Network Server
        //jsonFileUrl = [NSURL URLWithString:@"http://192.168.100.100:8888/ladenburg/service-lb-en.php"];
        
        
        // Huawei
        jsonFileUrl = [NSURL URLWithString:@"http://192.168.1.150:8888/ladenburg/service-lb-en.php"];
    }
    
    
    
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSLog(@"Request Created");

    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    NSLog(@"Connection created");
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
 
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
           NSLog(@"Response received");

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    // Append the newly downloaded data
    [_downloadedData appendData:data];
    NSLog(@"Data received");

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finishedLoading called \nDownloaded Data: %@", _downloadedData);
    // Create an array to store the sights
    NSMutableArray *_sights = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"error: %@", error);
    
    NSLog(@"Json Array: %@", jsonArray);
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new sight object and set its props to JsonElement properties
        Sight *newSight = [[Sight alloc] init];
        newSight.identifier = jsonElement[@"ID"];
        newSight.name = jsonElement[@"Name"];
        newSight.address = jsonElement[@"Address"];
        newSight.latitude = jsonElement[@"LOC_LATITUDE"];
        newSight.longitude = jsonElement[@"LOC_LONGITUDE"];
        //newSight.latitude = jsonElement[@"LOC_LATITUDE"];
        newSight.kurzbeschreibung = jsonElement[@"Kurzbeschreibung"];
        newSight.geschichte = jsonElement[@"Geschichte"];
        newSight.besonderheiten = jsonElement[@"Besonderheiten"];
        newSight.sonstiges = jsonElement[@"Oeffnungszeiten"];
        newSight.imageUrl = jsonElement[@"bild_url"];
        
        
        //set image property of newSight to image

        // Webspace Tim
        // baseURL = @"http://ladenburg.timhartl.de";
        
        // m-ladenburg server
         //baseURL = @"http://m-ladenburg.de";
        
        // Lokale Installation
        // baseURL = @"http://localhost:8888/";
        
        // Locale Nework Installation
        // Replace URL with IP of Network Server
        
        // baseURL = @"http://192.168.100.100:8888/";
        
        // Huawei
        baseURL = @"http://192.168.1.150:8888/";
        
        
        shortenedImageURL = [newSight.imageUrl substringFromIndex:2];
        fullURL = [baseURL stringByAppendingString:shortenedImageURL];
        url = [NSURL URLWithString:fullURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        newSight.image = [[UIImage alloc] initWithData:data];
        
        // Add this question to the sights array
        [_sights addObject:newSight];
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_sights];
    }
}

@end
