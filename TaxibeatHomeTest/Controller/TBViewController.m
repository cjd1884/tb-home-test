//
//  ViewController.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 24/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import "TBViewController.h"
#import "VenuesResponse.h"
#import "VenueResponse.h"
#import "TBAPIManager.h"
#import "TBVenueViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+Drawing.h"

#define IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

CGFloat kOffset = 14.0f;
CGFloat kAnimationDuration = 0.2f;
NSString *kCandystoreCatergoryId = @"4bf58dd8d48988d117951735";

@interface TBViewController () {
    CLLocationManager *_locationAuthorizationManager;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerTopConstraint;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) NSMutableArray *markers;
@property (strong, nonatomic) NSMutableArray *venues;

@end

@implementation TBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide venue container
    self.containerTopConstraint.constant = -kOffset - self.containerView.frame.size.height;
    
    // Set Google Maps view delegate
    self.mapView.delegate = self;
    
    // Initiate location manager
    _locationAuthorizationManager = [[CLLocationManager alloc] init];
    _locationAuthorizationManager.delegate = self;
    _locationAuthorizationManager.distanceFilter = 20.0;
    
    // Try too enable location updates
    [self enableMyLocation];
    
    self.markers = [[NSMutableArray alloc] init];
    self.venues = [[NSMutableArray alloc] init];
    
    // Set logo
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    self.navigationItem.titleView = logoImageView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Geocoding
-(void)reverseGeocodeWithCoordinates:(CLLocationCoordinate2D)coordinates {
    
    // Reverse geocode
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinates completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
        // Get reverse geocoded address
        GMSAddress* addressObj = (GMSAddress*)[response firstResult];
        
        // Sanitize address string
        [self.addressLabel setText:[self sanitizeAddressWithThoroughfare:addressObj.thoroughfare andLocality:addressObj.locality]];
        
    }];
    
    // Fetch candy shops around (limited to 10 results)
    [[TBAPIManager sharedManager] getVenuesWithLat:coordinates.latitude lon:coordinates.longitude andCategoryId:kCandystoreCatergoryId success:^(VenuesResponse *response) {
        NSArray *venues = response.venues;
        if (venues.count > 0) {
            // Empty venue array
            [self.venues removeAllObjects];
            
            // Populate venues on the map
            [self populateMapWithVenues:venues selected:nil];
            
            // Update array with newly fetched venues
            for (Venue *venue in venues) {
                [self.venues addObject:venue];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"Error fetching venues: %@", error.description);
    }];
    
    
}

-(NSString*)sanitizeAddressWithThoroughfare:(NSString*)thoroughfare andLocality:(NSString*)locality {
    
    if (thoroughfare != nil && locality != nil) {
        return [NSString stringWithFormat:@"%@, %@", thoroughfare, locality];
    }
    
    if (thoroughfare == nil && locality != nil) {
        return locality;
    }
    
    if (thoroughfare != nil && locality == nil) {
        return thoroughfare;
    }
    
    return NSLocalizedString(@"Address unavailable", nil);
}

#pragma mark - Map helpers
-(void)populateMapWithVenues:(NSArray*)venues selected:(Venue*)selectedVenue {
    
    // Clear mapview
    [self.mapView clear];
    [self.markers removeAllObjects];
    
    // Add markers on the map
    for (Venue *venue in venues) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(venue.location.lat.doubleValue, venue.location.lon.doubleValue);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.icon = [UIImage imageNamed:@"ico-venue"];
        marker.title = venue.venueId;
        marker.map = self.mapView;
        if (selectedVenue != nil && [selectedVenue.venueId isEqualToString:venue.venueId]) {
            [self updateIconOfMarker:marker withVenue:venue selected:YES];
        } else {
            [self updateIconOfMarker:marker withVenue:venue selected:NO];
        }
        [self.markers addObject:marker];
    }
}

-(void)updateIconOfMarker:(GMSMarker*) marker withVenue:(Venue*)venue selected:(BOOL)isSelected {
    if (venue.categories.count > 0) {
        // Deside base marker image depending selection
        UIImage *baseImage;
        if (isSelected) {
            baseImage = [UIImage imageNamed:@"ico-venue-selected"];
        } else {
            baseImage = [UIImage imageNamed:@"ico-venue"];
        }
        // Get primary category
        VenueCategory *category = venue.categories[0];
        
        // Fetch category icon image from foursquare api and update marker
        UIImageView *imageView = [[UIImageView alloc] init];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@64%@", category.prefix, category.suffix]]];
        [imageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            if ([self iPhone6PlusDevice]) {
                marker.icon = [UIImage drawImage:image inImage:baseImage atPoint:CGPointMake(4, 4)];
            } else {
                marker.icon = [UIImage drawImage:image inImage:baseImage atPoint:CGPointMake(-1, -1)];
            }
            marker.map = self.mapView;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }
}

-(void)selectMarkerWithVenue:(Venue*)venue {
    
    // Update delegate
    [self.delegate markerSelectedWithVenue:venue];

    // Show container view
    [self showContainerView];
    
}

-(void)showContainerView {
    
    [self.view layoutIfNeeded];
    
    // Animate container view
    [UIView animateWithDuration:kAnimationDuration * 2
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerTopConstraint.constant = kOffset;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         //
                     }];
}

-(void)hideContainerView {
    
    [self.view layoutIfNeeded];
    
    // Animate container view
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.containerTopConstraint.constant = -kOffset - self.containerView.frame.size.height;
        [self.view layoutIfNeeded];
    }];
}



#pragma mark - Google Maps delegate
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    // Get coordinates
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    // Reverse geocode
    [self reverseGeocodeWithCoordinates:CLLocationCoordinate2DMake(latitude, longitude)];
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    // Hide container view
    [self hideContainerView];
    
    // Fetch venue details
    [[TBAPIManager sharedManager] getVenueWithId:marker.title success:^(VenueResponse *response) {
        Venue *venue = response.venue;
        
        // Deselect all markers except selected (update map)
        [self populateMapWithVenues:self.venues selected:venue];
        
        // Select current venue
        [self selectMarkerWithVenue:venue];
        
    } failure:^(NSError *error) {
        NSLog(@"Error fetching venue details: %@", error.description);
    }];
    
    return YES;
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    // Hide container view
    [self hideContainerView];
    
    // Deselect all markers
    [self populateMapWithVenues:self.venues selected:nil];
}

#pragma mark - Location
- (void)enableMyLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        // Request user authorization
        [_locationAuthorizationManager requestWhenInUseAuthorization];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        // No authorization provided - free up resources
        _locationAuthorizationManager = nil;
        _locationAuthorizationManager.delegate = nil;
        return;
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // User location can be used - obtain user location
        [self.mapView setMyLocationEnabled:YES];
    }
}

#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self performSelectorOnMainThread:@selector(enableMyLocation) withObject:nil waitUntilDone:[NSThread isMainThread]];
        [_locationAuthorizationManager startUpdatingLocation];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // Stop updating location (save power resources)
    [manager stopUpdatingLocation];
    
    // User location available - retrieve coordinates
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D coordinates = [newLocation coordinate];
    
    // Set the Google Maps camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinates.latitude
                                                            longitude:coordinates.longitude
                                                                 zoom:12];
    self.mapView.camera = camera;
    
    // Reverse geocode user location
    [self reverseGeocodeWithCoordinates:coordinates];
    
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"VenueEmbededController"]) {
        TBVenueViewController *vc = segue.destinationViewController;
        self.delegate = vc;
    }
}

#pragma mark - Helper
-(BOOL)iPhone6PlusDevice{
    if (!IS_PHONE) return NO;
    if ([UIScreen mainScreen].scale > 2.9) return YES;   // Scale is only 3 when not in scaled mode for iPhone 6 Plus
    return NO;
}

@end
