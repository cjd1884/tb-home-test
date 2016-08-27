//
//  VenueResponse.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 26/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import "VenueResponse.h"

@implementation VenueResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"venue" : @"response.venue" };
}

#pragma mark - JSON Transformer

+ (NSValueTransformer *)venueJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Venue.class];
}

@end
