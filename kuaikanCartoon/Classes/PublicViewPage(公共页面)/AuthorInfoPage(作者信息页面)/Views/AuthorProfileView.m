//
//  AuthorProfileView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorProfileView.h"
#import <Masonry.h>
#import "CommonMacro.h"


@implementation AuthorProfileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *jianjie = [[UILabel alloc] init];
    
    jianjie.textColor = [UIColor lightGrayColor];
    jianjie.text = @"简介";
    jianjie.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:jianjie];
    
    [jianjie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(SPACEING);
        make.right.equalTo(self).offset(-SPACEING);
        make.height.equalTo(@(15));
    }];
    
    
    UILabel *profileLabel = [[UILabel alloc] init];
    
    profileLabel.numberOfLines = 0;
    profileLabel.textColor = [UIColor darkGrayColor];
    profileLabel.text = @"作者辛苦赶稿,都没来得及填写资料哦";
    profileLabel.font = [UIFont systemFontOfSize:14];
    profileLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    profileLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - SPACEING * 2;
    
    [self addSubview:profileLabel];
    
    [profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jianjie);
        make.right.bottom.equalTo(self).offset(-SPACEING);
        make.top.equalTo(jianjie.mas_bottom).offset(SPACEING);
    }];
    
    _profileText = profileLabel;

}

@end
