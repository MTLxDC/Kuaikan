//
//  HomeNavBarTitleView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface navBarTitleView : UIView

@property (nonatomic,weak,readonly) UIButton *leftBtn;

@property (nonatomic,weak,readonly) UIButton *rightBtn;

@property (nonatomic,copy) void (^leftBtnOnClick)(UIButton *btn);

@property (nonatomic,copy) void (^rightBtnOnClick)(UIButton *btn);

- (void)selectBtn:(UIButton *)btn;


+ (instancetype)defaultTitleView;

@end
