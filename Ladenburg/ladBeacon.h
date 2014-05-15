//
//  ladBeacon.h
//  Ladenburg
//
//  Created by Sonja on 14.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ladBeacon : NSObject

@property (strong) NSString *uuid;
@property NSInteger major;
@property NSInteger minor;
@property (strong) NSString *identifier;


- (id) initWithUUID: (NSString* )uuid andMajor: (NSInteger)major andMinor:(NSInteger)minor andIdentifier:(NSString *)identifier;

@end
