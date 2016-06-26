





//
//  NoResultTipView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/22.
//  Copyright © 2016年 name. All rights reserved.
//

#import "NoResultTipView.h"
#import <Masonry.h>

static CGFloat spaceing = 8.0;

@implementation NoResultTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *nodata = [UIImageView new];
    
    nodata.image = [UIImage imageNamed:@"ic_search_empty_82x104_"];
    
    [self addSubview:nodata];
    
    [nodata mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(spaceing);
        make.height.equalTo(@104);
        make.width.equalTo(@82);
        make.centerX.equalTo(self);
    }];
    
    UILabel *tipLabel  = [UILabel new];
    
    tipLabel.text = @"无结果~";
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self);
        make.top.equalTo(nodata.mas_bottom).offset(spaceing);
    }];
    
}

@end
