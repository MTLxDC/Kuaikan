//
//  HomeNavBarTitleView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface navBarTitleView : UIView

@property (nonatomic,weak,readonly) UIButton *leftButton;

@property (nonatomic,weak,readonly) UIButton *rightButton;




+ (instancetype)defaultTitleView;

@end
