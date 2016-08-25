//
//  VenueTest.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 25/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Venue.h"

@interface VenueTest : XCTestCase {
    Venue *venue;
}

@end

@implementation VenueTest

- (void)setUp {
    [super setUp];
    venue = [[Venue alloc] init];
}

- (void)tearDown {
    venue = nil;
    [super tearDown];
}

- (void)testVenueAttributes {
    NSString *venueIdString = @"d2398hf4y3948f43hf349872ff20f2k";
    NSString *venueNameString = @"Sweet Dreams";
    venue.venueId = venueIdString;
    venue.name = venueNameString;
    XCTAssertEqual(venueIdString, venue.venueId);
    XCTAssertEqual(venueNameString, venue.name);
}

- (void)testVenueLocation {
    Location *location = [[Location alloc] init];
    NSString *addressString = @"St. Peter Street 32";
    NSNumber *latNumber = [NSNumber numberWithDouble:37.9783297513983];
    NSNumber *lonNumber = [NSNumber numberWithDouble:23.724882569985553];
    location.address = addressString;
    location.lat = latNumber;
    location.lon = lonNumber;
    venue.location = location;
    XCTAssertEqual(addressString, venue.location.address);
    XCTAssertEqual(latNumber, venue.location.lat);
    XCTAssertEqual(lonNumber, venue.location.lon);
}

- (void)testVenueCategories {
    VenueCategory *category = [[VenueCategory alloc] init];
    NSString *nameString = @"Candy shops";
    category.name = nameString;
    venue.categories = @[category];
    XCTAssertEqual(1, venue.categories.count);
    XCTAssertEqual(nameString, ((VenueCategory*)venue.categories[0]).name);
}

@end
