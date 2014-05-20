//
//  Sight.h
//  Ladenburg
//
//  Created by Tim Hartl on 15.05.14.
//  Copyright (c) 2014 DHBW Mannheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sight : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *kurzbeschreibung;
@property (nonatomic, strong) NSString *geschichte;
@property (nonatomic, strong) NSString *besonderheiten;
@property (nonatomic, strong) NSString *sonstiges;
@property (nonatomic, strong) NSString *imageUrl;

@end
