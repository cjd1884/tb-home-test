//
//  Photo.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 27/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import "Photo.h"

@implementation Photo

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prefix": @"prefix",
             @"suffix": @"suffix"
             };
}

@end
