//
//  Photo.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 27/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Photo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *suffix;

@end
