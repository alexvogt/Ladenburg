//
//  HomeModel.h
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeModelProtocol <NSObject>

- (void)sightsDownloaded:(NSArray *)sightsArray ;
- (void)exhibitsDownloaded:(NSArray *)exhibitsArray;

@end

@interface HomeModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<HomeModelProtocol> delegate;

-(void)downloadItems;

@end
