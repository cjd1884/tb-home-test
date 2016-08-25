//
//  Location.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Location : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSNumber *lat;
@property(nonatomic, strong)NSNumber *lon;

@end
