//
//  Venue.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import "Venue.h"
#import "Location.h"
#import "VenueCategory.h"

@implementation Venue

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"venueId": @"id",
             @"name": @"name",
             @"location": @"location",
             @"categories": @"categories"
             };
}

#pragma mark - JSON Transformer

+ (NSValueTransformer *)locationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Location.class];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:VenueCategory.class];
}

@end
