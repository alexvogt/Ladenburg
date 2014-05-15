//
//  ladBeacon.m
//  Ladenburg
//
//  Created by Sonja on 14.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import "ladBeacon.h"

@implementation ladBeacon


- (id) initWithUUID: (NSString* )uuid andMajor: (NSInteger)major andMinor:(NSInteger)minor andIdentifier:(NSString *)identifier {
    
    self = [self init];
    if (self) {
        self.uuid = uuid;
        self.minor = minor;
        self.major = major;
        self.identifier = identifier;
    }
    return self;
}

@end
