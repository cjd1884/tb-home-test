//
//  Location.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import "Location.h"

@implementation Location

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address": @"address",
             @"lat": @"lat",
             @"lon": @"lng"
             };
}

@end
