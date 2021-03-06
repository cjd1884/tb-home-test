//
//  TBAPIManager.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import "TBSessionManager.h"
#import "VenuesResponse.h"
#import "VenueResponse.h"

@interface TBAPIManager : TBSessionManager

- (NSURLSessionDataTask *)getVenuesWithLat:(double)lat
                                       lon:(double)lon
                             andCategoryId:(NSString*)categoryId
                                   success:(void (^)(VenuesResponse *response))success
                                   failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenueWithId:(NSString*)venueId
                             success:(void (^)(VenueResponse *response))success
                             failure:(void (^)(NSError *error))failure;


@end
