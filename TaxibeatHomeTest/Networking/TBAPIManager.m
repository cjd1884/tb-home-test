//
//  TBAPIManager.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import "TBAPIManager.h"

@implementation TBAPIManager

- (NSURLSessionDataTask *)getVenuesWithLat:(double)lat
                                       lon:(double)lon
                                  andQuery:(NSString*)query
                                   success:(void (^)(VenuesResponse *response))success
                                   failure:(void (^)(NSError *error))failure {
    
    NSString *encodedQueryString = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?ll=%lf,%lf&query=%@&limit=10&client_id=%@&client_secret=%@&v=20160825", kBaseURL, kSearchURL, lat, lon, encodedQueryString, kClientId, kClientSecret];
    
    return [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        
        NSError *error;
        VenuesResponse *venues = [MTLJSONAdapter modelOfClass:VenuesResponse.class
                                                   fromJSONDictionary:responseDictionary error:&error];
        success(venues);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getVenueWithId:(NSString*)venueId
                             success:(void (^)(VenueResponse *response))success
                             failure:(void (^)(NSError *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?client_id=%@&client_secret=%@&v=20160825", kBaseURL, kVenueURL, venueId, kClientId, kClientSecret];
    
    return [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        
        NSError *error;
        VenueResponse *venue = [MTLJSONAdapter modelOfClass:VenueResponse.class
                                         fromJSONDictionary:responseDictionary error:&error];
        success(venue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
