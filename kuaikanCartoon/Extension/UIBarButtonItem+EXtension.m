//
//  UIBarButtonItem+EXtension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIBarButtonItem+EXtension.h"

@implementation UIBarButtonItem (EXtension)


+ (instancetype)barButtonItemWithImage:(NSString *)image
                            pressImage:(NSString *)pressImage
                                target:(id)target action:(SEL)action
{
    return [[[self class] alloc] initWithImage:image pressImage:pressImage target:target action:action];
}
- (instancetype)initWithImage:(NSString *)image
                   pressImage:(NSString *)pressImage
                       target:(id)target action:(SEL)action
{
    
    UIButton *btn = [UIButton new];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:pressImage] forState:UIControlStateSelected];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn sizeToFit];
    
    return [self initWithCustomView:btn];
}
@end
