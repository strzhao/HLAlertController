//
//  UIImage+HLColor.m
//  HLAlertController
//
//  Created by String on 15/5/29.
//  Copyright (c) 2015年 ___string___. All rights reserved.
//

#import "UIImage+HLColor.h"

@implementation UIImage (HLColor)

+ (UIImage *)HL_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
