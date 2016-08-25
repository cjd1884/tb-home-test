//
//  VenueCategory.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import "VenueCategory.h"

@implementation VenueCategory

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"name": @"name" };
}

@end
