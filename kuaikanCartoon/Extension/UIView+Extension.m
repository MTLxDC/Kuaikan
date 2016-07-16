//
//  UIView+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIViewController *)myViewController {
    return [self findResponderWithClass:[UIViewController class]];
}

- (void)cornerRadius:(CGFloat)size
{
    if (size == 0) size = self.height * 0.5;
    
    self.layer.cornerRadius = size;
    self.layer.masksToBounds = YES;
    
}

- (id)findResponderWithClass:(Class)aclass
{
    UIResponder *nextResponder = self.nextResponder;
    
    while (nextResponder) {
        
        if ([nextResponder isKindOfClass:aclass]) {
            return nextResponder;
        }
        
        nextResponder = nextResponder.nextResponder;
    }
    
    return nil;
}






- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}
- (void)setY:(CGFloat)y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}
- (void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}
- (void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

@end
