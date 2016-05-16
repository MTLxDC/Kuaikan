//
//  FindHeaderSectionView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/15.
//  Copyright © 2016年 name. All rights reserved.
//
#import <Masonry.h>
#import "FindHeaderSectionView.h"
#import "Color.h"
#import "UIView+Extension.h"

static const CGFloat spaceing = 12.0f;
static const CGFloat contentHeight = 20.0f;

static NSString * const Leaderboard = @"每周排行榜";

@interface FindHeaderSectionView ()

@property (nonatomic,weak) UILabel *titleView;

@property (nonatomic,weak) UIButton *moreBtn;

@end

@implementation FindHeaderSectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    
    CGFloat w = 5;
    
    UIView *yellowView = [[UIView alloc] init];
    
    yellowView.backgroundColor = subjectColor;
    yellowView.layer.cornerRadius  = w * 0.5;
    yellowView.layer.masksToBounds = YES;
    
    [self addSubview:yellowView];
    
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(spaceing);
        make.height.equalTo(@(contentHeight));
        make.width.equalTo(@(w));
    }];
    
    
    UILabel *titleView = [[UILabel alloc] init];
    
    titleView.font = [UIFont systemFontOfSize:16];
    titleView.textColor = White(0.5);
    
    [self addSubview:titleView];
    
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(yellowView.mas_right).offset(spaceing * 0.5);
        make.height.equalTo(@(contentHeight));
    }];
    
    self.titleView = titleView;
    
    
    
    UIButton *more = [[UIButton alloc] init];
    
    [more setImage:[UIImage imageNamed:@"ic_discover_more_22x22_"] forState:UIControlStateNormal];
    [more setImage:[UIImage imageNamed:@"ic_discover_more-pressed_22x22_"] forState:UIControlStateHighlighted];
    
    [more addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:more];
    
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-spaceing);
        make.height.equalTo(@(contentHeight));
    }];

    
    self.moreBtn = more;
}

- (void)setTitle:(NSString *)title {
    self.titleView.text = title;
    
    if ([title isEqualToString:Leaderboard]) {        
        [self.moreBtn setImage:[UIImage imageNamed:@"ic_discover_time_15x15_"] forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"每周一出榜" forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.moreBtn.userInteractionEnabled = NO;
        
        [self.moreBtn.titleLabel sizeToFit];
    }
}

- (void)more {
    if (self.moreOnClick) {
        self.moreOnClick();
    }
}

@end
