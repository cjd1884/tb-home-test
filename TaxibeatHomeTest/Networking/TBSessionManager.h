//
//  TBSessionManager.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

static NSString *const kBaseURL = @"https://api.foursquare.com";
static NSString *const kSearchURL = @"/v2/venues/search";
static NSString *const kVenueURL = @"/v2/venues";
static NSString *const kClientId = @"0DYNEMDDNGUERL3PTPIYCQDZAA50MUZLNGKB3OOJD3PRIC2N";
static NSString *const kClientSecret = @"21THYM0HZH1DD0LUASK4QVNDQWZU4O2BRFPJCCDZBZQM3K1S";

@interface TBSessionManager : AFHTTPSessionManager

+ (id)sharedManager;

@end
