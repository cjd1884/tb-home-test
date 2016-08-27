//
//  UIImage+Drawing.h
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 27/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Drawing)

+(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point;

@end
