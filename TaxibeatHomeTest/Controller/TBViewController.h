//
//  TBViewController.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 24/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Venue.h"
@import GoogleMaps;

@protocol TBVenueSelectionDelegate <NSObject>

@optional
- (void) markerSelectedWithVenue:(Venue*)venue;

@end

@interface TBViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (nonatomic,strong) id <TBVenueSelectionDelegate> delegate;

@end

