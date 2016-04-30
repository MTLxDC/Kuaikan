//
//  HomeNavBarTitleView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "navBarTitleView.h"
#import "CommonMacro.h"
#import "UIView+Extension.h"

@implementation navBarTitleView


static CGFloat const MyHeight = 30;

+ (instancetype)defaultTitleView {
    return  [[self alloc] initWithFrame:CGRectMake(0,navHeight - MyHeight,SCREEN_WIDTH * 0.33, MyHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
    UIButton *btn1 = [self creatBtn];
    
    [self addSubview:btn1];
    
    UIButton *btn2 = [self creatBtn];
    
    [self addSubview:btn2];

    
    _leftButton = btn1;
    _rightButton = btn2;
}

- (UIButton *)creatBtn {
    
    UIButton *btn = [UIButton new];
    
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    btn.layer.cornerRadius = MyHeight * 0.5;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.width * 0.5;
    
    self.leftButton.frame = CGRectMake(0, 0, w, self.height);
    self.rightButton.frame = CGRectMake(w, 0, w, self.height);
    
}



@end
