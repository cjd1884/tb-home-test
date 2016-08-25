//
//  Venue.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import "Location.h"
#import "VenueCategory.h"

@interface Venue : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy)NSString *venueId;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)Location *location;
@property(nonatomic, copy)NSArray *categories;

@end
