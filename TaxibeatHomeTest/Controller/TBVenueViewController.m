//
//  TBVenueViewController.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 26/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import "TBVenueViewController.h"
#import "VenueCategory.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TaxibeatHomeTest-Swift.h"

@interface TBVenueViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation TBVenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customize container view
    self.containerView.layer.borderColor = [TBGlobals sharedInstance].kTBColorGrayWithRed.CGColor;
    self.containerView.layer.borderWidth = 6.0;
    self.containerView.layer.cornerRadius = 8.0;
    
    // Customize rating label
    self.ratingLabel.layer.borderColor = [TBGlobals sharedInstance].kTBColorMaroonVeryLight.CGColor;
    self.ratingLabel.layer.borderWidth = 4.0;
    self.ratingLabel.layer.cornerRadius = self.ratingLabel.frame.size.width/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TBVenueSelectionDelegate
-(void)markerSelectedWithVenue:(Venue *)venue {
    
    // Update name
    self.nameLabel.text = venue.name;
    
    // Update address
    self.addressLabel.text = venue.location.address;
    
    // Update category
    if (venue.categories.count > 0) {
        self.categoryLabel.text = ((VenueCategory*)venue.categories[0]).name;
    } else {
        self.categoryLabel.text = @"";
    }
    
    // Update rating
    if (venue.rating.floatValue == 0.0f) {
        self.ratingLabel.text = @"N/A";
    } else {
        self.ratingLabel.text = [NSString stringWithFormat:@"%.1lf", venue.rating.floatValue];
    }
    
    // Update image
    [self.imageView setImage:nil];
    if (venue.bestPhoto != nil) {
        NSString *dimensionString = [NSString stringWithFormat:@"%ldx%ld", (unsigned long)(3 * self.imageView.frame.size.width), (unsigned long)(3 * self.imageView.frame.size.height)];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", venue.bestPhoto.prefix, dimensionString, venue.bestPhoto.suffix]]];
        [self.activityIndicator startAnimating];
        [self.imageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [self.activityIndicator stopAnimating];
            [self.imageView setImage:image];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [self.activityIndicator stopAnimating];
            [self.imageView setImage:[UIImage imageNamed:@"placeholder"]];
            self.imageView.contentMode = UIViewContentModeCenter;
        }];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    } else {
        [self.activityIndicator stopAnimating];
        [self.imageView setImage:[UIImage imageNamed:@"placeholder"]];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
}

@end
