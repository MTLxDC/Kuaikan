//
//  DCPicItemConfiguration.m
//  DCWebPicScrollView
//
//  Created by dengchen on 16/5/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import "DCPicItemConfiguration.h"

@implementation DCPicItemConfiguration

+ (instancetype)defaultConfiguration {
    
    DCPicItemConfiguration *pic = [[DCPicItemConfiguration alloc] init];
    
    pic.contentMode = UIViewContentModeScaleAspectFill;
    pic.showBottomView = NO;
    
    return pic;
}

+ (instancetype)hasTitleViewConfiguration {
    
    DCPicItemConfiguration *pic = [[DCPicItemConfiguration alloc] init];
    
    pic.showBottomView = YES;
    pic.bottomViewHeight = 25;
    pic.textColor   = [UIColor whiteColor];
    pic.textFont    = [UIFont systemFontOfSize:15];
    pic.bgColor     = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    pic.contentMode = UIViewContentModeScaleAspectFill;
    
    return pic;
}
@end
