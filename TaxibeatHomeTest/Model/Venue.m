//
//  Venue.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
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
             @"categories": @"categories",
             @"rating": @"rating",
             @"bestPhoto": @"bestPhoto"
             };
}

#pragma mark - JSON Transformer

+ (NSValueTransformer *)locationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Location.class];
}

+ (NSValueTransformer *)bestPhotoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Photo.class];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:VenueCategory.class];
}

@end
