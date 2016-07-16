//
//  UIView+Extension.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Extension)

- (UIViewController *)myViewController;

- (void)cornerRadius:(CGFloat)size;

- (id)findResponderWithClass:(Class)aclass;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

@end
