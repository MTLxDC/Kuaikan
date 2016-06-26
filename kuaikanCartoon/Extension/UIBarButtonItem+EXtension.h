//
//  UIBarButtonItem+EXtension.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (EXtension)


+ (instancetype)barButtonItemWithImage:(NSString *)image
                   pressImage:(NSString *)pressImage
                       target:(id)target action:(SEL)action;

- (instancetype)initWithImage:(NSString *)image
                   pressImage:(NSString *)pressImage
                       target:(id)target action:(SEL)action;
@end
