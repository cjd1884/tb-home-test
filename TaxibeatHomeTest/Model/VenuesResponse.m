//
//  VenuesResponse.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import "VenuesResponse.h"
#import "Venue.h"

@implementation VenuesResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"venues" : @"response.venues" };
}

#pragma mark - JSON Transformer

+ (NSValueTransformer *)venuesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Venue.class];
}

@end
