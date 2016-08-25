//
//  ViewController.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 24/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
//

#import "TBViewController.h"

@interface TBViewController () {
    CLLocationManager *_locationAuthorizationManager;
}

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation TBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Google Maps view delegate
    self.mapView.delegate = self;
    
    // Initiate location manager
    _locationAuthorizationManager = [[CLLocationManager alloc] init];
    _locationAuthorizationManager.delegate = self;
    _locationAuthorizationManager.distanceFilter = 20.0;
    
    // Try too enable location updates
    [self enableMyLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Geocoding
-(void)reverseGeocodeWithCoordinates:(CLLocationCoordinate2D)coordinates {
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinates completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
        // Get reverse geocoded address
        GMSAddress* addressObj = (GMSAddress*)[response firstResult];
        
        // Sanitize address string
        [self.addressLabel setText:[self sanitizeAddressWithThoroughfare:addressObj.thoroughfare andLocality:addressObj.locality]];
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

#pragma mark - Google Maps delegate
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    // Get coordinates
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    // Reverse geocode
    [self reverseGeocodeWithCoordinates:CLLocationCoordinate2DMake(latitude, longitude)];
}

#pragma mark - Location authorization
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

@end
