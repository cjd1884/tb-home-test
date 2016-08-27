//
//  TBVenueViewController.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 26/08/16.
//  Copyright © 2016 taxibeat. All rights reserved.
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
    self.nameLabel.text = venue.name;
    self.addressLabel.text = venue.location.address;
    if (venue.categories.count > 0) {
        self.categoryLabel.text = ((VenueCategory*)venue.categories[0]).name;
    } else {
        self.categoryLabel.text = @"";
    }
    if (venue.rating.floatValue == 0.0f) {
        self.ratingLabel.text = @"N/A";
    } else {
        self.ratingLabel.text = [NSString stringWithFormat:@"%.1lf", venue.rating.floatValue];
    }
    [self.imageView setImage:nil];
    if (venue.bestPhoto != nil) {
        NSString *dimensionString = [NSString stringWithFormat:@"%ldx%ld", (unsigned long)(3 * self.imageView.frame.size.width), (unsigned long)(3 * self.imageView.frame.size.height)];
        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", venue.bestPhoto.prefix, dimensionString, venue.bestPhoto.suffix]]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"placeholder"]];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
}

@end
