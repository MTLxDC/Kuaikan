//
//  wordsOptionsHeadView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import "wordsOptionsHeadView.h"
#import <Masonry.h>
#import "CommonMacro.h"
#import "Color.h"

@interface wordsOptionsHeadView ()

@property (nonatomic,weak) UIButton *leftBtn;

@property (nonatomic,weak) UIButton *rightBtn;

@property (nonatomic,weak) UIView *line;

@property (nonatomic,strong) MASConstraint *lineConstraint;

@end

@implementation wordsOptionsHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.leftBtn  = [self creatBtn];
    
    [self.leftBtn setTitle:@"简介" forState:UIControlStateNormal];
    
    self.rightBtn = [self creatBtn];
    
    [self.rightBtn setTitle:@"内容" forState:UIControlStateNormal];

    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBtn.mas_right);
        make.width.equalTo(self.leftBtn);
        make.right.top.bottom.equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
       self.lineConstraint = make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@3);
        make.width.equalTo(self.leftBtn);
    }];
    
    
    UIView *bottomLine = [self creatSpaceLine];
    UIView *centerLine = [self creatSpaceLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self);
        make.width.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
}

- (void)btnClick:(UIButton *)btn {
    
    btn.selected = YES;
    
    if (btn == self.leftBtn) {
        self.rightBtn.selected = NO;
        
        self.lineConstraint.offset(-self.leftBtn.bounds.size.width);
        
        if (self.lefeBtnClick) {
            self.lefeBtnClick(self.leftBtn);
        }
    }else{
        
        self.leftBtn.selected = NO;
        
        [self.lineConstraint setOffset:0];
        
        if (self.rightBtnClick) {
            self.rightBtnClick(self.rightBtn);
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (UIButton *)creatBtn {
    
    UIButton *btn = [[UIButton alloc] init];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[[UIColor alloc] initWithWhite:0.5 alpha:1] forState:UIControlStateSelected];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
    return btn;
}

- (UIView *)creatSpaceLine {
    
    UIView *spaceLine = [[UIView alloc] init];
    spaceLine.backgroundColor = [[UIColor alloc] initWithWhite:9 alpha:1];
    [self addSubview:spaceLine];
    
    return spaceLine;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = subjectColor;
        [self addSubview:line];
        _line = line;
    }
    return _line;
}


@end
