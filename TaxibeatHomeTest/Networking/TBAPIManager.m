//
//  TBAPIManager.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import "TBAPIManager.h"

@implementation TBAPIManager

- (NSURLSessionDataTask *)getVenuesWithLat:(double)lat
                                       lon:(double)lon
                             andCategoryId:(NSString*)categoryId
                                   success:(void (^)(VenuesResponse *response))success
                                   failure:(void (^)(NSError *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?ll=%lf,%lf&categoryId=%@&limit=10&client_id=%@&client_secret=%@&v=%@", kBaseURL, kSearchURL, lat, lon, categoryId, kClientId, kClientSecret, [self dateString]];
    
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?client_id=%@&client_secret=%@&v=%@", kBaseURL, kVenueURL, venueId, kClientId, kClientSecret, [self dateString]];
    
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

#pragma mark - Helper
- (NSString*)dateString {
    
    // Create formatter and set its date format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    // Return date string
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
