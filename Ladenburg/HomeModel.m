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
}
@end

@implementation HomeModel

- (void)downloadItems
{
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://ladenburg.timhartl.de/service-lb-th.php"];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the sights
    NSMutableArray *_sights = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new sight object and set its props to JsonElement properties
        Sight *newSight = [[Sight alloc] init];
        newSight.identifier = jsonElement[@"ID"];
        newSight.name = jsonElement[@"Name"];
        newSight.address = jsonElement[@"Address"];
        //newSight.latitude = jsonElement[@"LOC_LATITUDE"];
        //newSight.longitude = jsonElement[@"LOC_LONGITUDE"];
        newSight.kurzbeschreibung = jsonElement[@"Kurzbeschreibung"];
        newSight.geschichte = jsonElement[@"Geschichte"];
        newSight.besonderheiten = jsonElement[@"Besonderheiten"];
        newSight.sonstiges = jsonElement[@"Oeffnungszeiten"];
        newSight.imageUrl = jsonElement[@"bild_url"];
        
        //set image property of newSight to image
        baseURL = @"http://ladenburg.timhartl.de";
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
