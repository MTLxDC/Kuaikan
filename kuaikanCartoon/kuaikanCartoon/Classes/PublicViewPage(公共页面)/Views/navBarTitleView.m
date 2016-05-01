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
#import <UIControl+BlocksKit.h>

@interface navBarTitleView ()

@property (nonatomic,weak,readwrite) UIButton *leftBtn;

@property (nonatomic,weak,readwrite) UIButton *rightBtn;

@end

@implementation navBarTitleView


static CGFloat const MyHeight = 30;

+ (instancetype)defaultTitleView {
    return  [[self alloc] initWithFrame:CGRectMake(0,navHeight - MyHeight,SCREEN_WIDTH * 0.33, MyHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    UIButton *btn1 = [self creatBtn];
    
    [self addSubview:btn1];
    
    UIButton *btn2 = [self creatBtn];
    
    [self addSubview:btn2];

    
    self.leftBtn = btn1;
    self.rightBtn = btn2;
    
    
    [self.leftBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"更新" forState:UIControlStateNormal];
    
    weakself(self);
    
    [self.leftBtn bk_addEventHandler:^(id sender) {
        
        [weakSelf selectBtn:weakSelf.leftBtn];
        
        if (weakSelf.leftBtnOnClick) {
            weakSelf.leftBtnOnClick(sender);
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightBtn bk_addEventHandler:^(id sender) {
        
        [weakSelf selectBtn:weakSelf.rightBtn];
        
        if (weakSelf.rightBtn) {
            weakSelf.rightBtnOnClick(sender);
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self selectBtn:self.rightBtn];

}

- (void)selectBtn:(UIButton *)btn {
    
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:subjectColor forState:UIControlStateNormal];
    
    if (btn == self.leftBtn) {
        [self.rightBtn setBackgroundColor:[UIColor clearColor]];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [self.leftBtn setBackgroundColor:[UIColor clearColor]];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


- (UIButton *)creatBtn {
    
    UIButton *btn = [UIButton new];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    btn.layer.cornerRadius = MyHeight * 0.5;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.width * 0.5;
    
    self.leftBtn.frame = CGRectMake(0, 0, w, self.height);
    self.rightBtn.frame = CGRectMake(w, 0, w, self.height);
    
}



@end
