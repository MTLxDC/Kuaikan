
//
//  UIImage+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)



- (UIImage *)clipImageToSize:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    
    CGSize imgSize = self.size;
    CGFloat x = MAX(size.width / imgSize.width, size.height / imgSize.height);
    CGSize resultSize = CGSizeMake(x* imgSize.width, x* imgSize.height);
    
    [self drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
    
}

@end
