//
//  UIImage+Drawing.m
//  TaxibeatHomeTest
//
//  Created by Konstantinos Dimitros on 27/08/16.
//  Copyright © 2016 Taxibeat. All rights reserved.
//

#import "UIImage+Drawing.h"

@implementation UIImage (Drawing)

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
