//
//  HomeNavBarTitleView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface navBarTitleView : UIView



@property (nonatomic,copy) void (^leftBtnOnClick)(UIButton *btn);

@property (nonatomic,copy) void (^rightBtnOnClick)(UIButton *btn);


+ (instancetype)defaultTitleView;

@end
