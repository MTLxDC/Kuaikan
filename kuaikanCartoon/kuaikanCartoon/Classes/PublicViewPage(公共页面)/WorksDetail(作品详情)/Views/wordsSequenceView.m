//
//  wordsSequenceView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/9.
//  Copyright © 2016年 name. All rights reserved.
//

#import "wordsSequenceView.h"
#import <Masonry.h>
#import "CommonMacro.h"

static CGFloat const spaceing = 8;

@implementation wordsSequenceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    sortBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);

    sortBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [sortBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    //倒序
     [sortBtn setImage:[UIImage imageNamed:@"ic_album_sort_descending_11x11_"] forState:    UIControlStateNormal];
    [sortBtn setTitle:@"倒序" forState:UIControlStateNormal];

    //升序
     [sortBtn setImage:[UIImage imageNamed:@"ic_album_sort_ascending_11x11_"] forState:UIControlStateSelected];
     [sortBtn setTitle:@"正序" forState:UIControlStateSelected];
    
    [self addSubview:sortBtn];
    
    [sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
    _sortBtn = sortBtn;
    
    UILabel *label = [UILabel new];
    
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [[UIColor alloc] initWithWhite:0.5 alpha:1];
    label.text = @"漫画列表";
    
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(spaceing);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [[UIColor alloc] initWithWhite:0.9 alpha:1];
    [self addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
}

@end
