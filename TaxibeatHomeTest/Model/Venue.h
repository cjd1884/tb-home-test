//
//  Venue.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "VenueCategory.h"

@interface Venue : NSObject

@property(nonatomic, strong)NSString *venueId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)Location *location;
@property(nonatomic, strong)NSArray *categories;

@end
