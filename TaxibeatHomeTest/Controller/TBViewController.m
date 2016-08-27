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
            Venue *venue = venues[0];
            if (venue.name != nil) {
                NSLog(@"%@", venue.name);
            }
            // Populate shops on the map
            [self.venues removeAllObjects];
            [self populateMapWithVenues:venues selected:nil];
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
        marker.map = self.mapView;
        marker.title = venue.venueId;
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
        UIImage *baseImage;
        if (isSelected) {
            baseImage = [UIImage imageNamed:@"ico-venue-selected"];
        } else {
            baseImage = [UIImage imageNamed:@"ico-venue"];
        }
        VenueCategory *category = venue.categories[0];
        UIImageView *imageView = [[UIImageView alloc] init];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@64%@", category.prefix, category.suffix]]];
        NSLog(@"%@", [NSString stringWithFormat:@"%@64%@", category.prefix, category.suffix]);
        [imageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            marker.icon = [TBViewController drawImage:image inImage:baseImage atPoint:CGPointMake(-1, -1)];
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
        if (venue.name != nil) {
            NSLog(@"Fetched venue with name: %@, rating: %lf", venue.name, venue.rating.floatValue);
        }
        // Deselect all markers except selected
        [self populateMapWithVenues:self.venues selected:venue];
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

+(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
