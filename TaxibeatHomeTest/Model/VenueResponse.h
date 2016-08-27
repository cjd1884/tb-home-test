//
//  VenueResponse.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 26/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "Venue.h"

@interface VenueResponse : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy)Venue *venue;

@end
