//
//  VenuesResponse.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface VenuesResponse : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy)NSArray *venues;

@end
