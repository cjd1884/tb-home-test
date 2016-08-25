//
//  Location.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSNumber *lat;
@property(nonatomic, strong)NSNumber *lon;

@end
