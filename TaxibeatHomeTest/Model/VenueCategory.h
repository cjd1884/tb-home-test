//
//  Category.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface VenueCategory : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong)NSString *name;

@end
