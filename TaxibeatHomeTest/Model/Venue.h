//
//  Venue.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import "Location.h"
#import "Photo.h"
#import "VenueCategory.h"

@interface Venue : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy)NSString *venueId;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)Location *location;
@property(nonatomic, copy)NSArray *categories;
@property(nonatomic, copy)NSNumber *rating;
@property(nonatomic, copy)Photo *bestPhoto;

@end
