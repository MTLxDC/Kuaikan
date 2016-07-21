
//
//  UIImage+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)clipEllipseImage{
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat size = MAX(self.size.width, self.size.height);
    CGRect rect  = CGRectMake(0, 0, size, size);

    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}

@end
