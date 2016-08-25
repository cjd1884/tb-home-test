//
//  TBAPIManager.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import "TBSessionManager.h"
#import "VenuesResponse.h"

@interface TBAPIManager : TBSessionManager

- (NSURLSessionDataTask *)getVenuesWithLat:(double)lat
                                       lon:(double)lon
                                  andQuery:(NSString*)query
                                   success:(void (^)(VenuesResponse *response))success
                                   failure:(void (^)(NSError *error))failure;


@end
