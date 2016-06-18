//
//  authorInfoHeadView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "authorInfoHeadView.h"
#import <Masonry.h>
#import "comicsModel.h"
#import "CommonMacro.h"
#import "UrlStringDefine.h"
#import "NetWorkManager.h"
#import <UIImageView+WebCache.h>
#import "ProgressHUD.h"
#import "UserInfoManager.h"

@interface authorInfoHeadView ()

@property (nonatomic,weak) UIImageView *authorIcon;

@property (nonatomic,weak) UILabel *authorName;

@property (nonatomic,weak) UIButton *follow;

@property (nonatomic,weak) UIView *line;

@end



@implementation authorInfoHeadView

static CGFloat spacing = 10;
static CGFloat imageSize = 40;
static CGFloat followSize = 21;


- (void)setModel:(comicsModel *)model {
    _model = model;
    [self updataUI];
}

- (void)updataUI {
    
    [self.authorIcon sd_setImageWithURL:[NSURL URLWithString:self.model.topic.user.avatar_url] placeholderImage:[UIImage imageNamed:@"ic_author_info_headportrait_50x50_"]];
    
    [self.authorName setText:self.model.topic.user.nickname];
    
    self.follow.selected = self.model.is_favourite;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    [self.authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(spacing);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(imageSize));
        
    }];
    
    [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.authorIcon.mas_right).offset(spacing);
        make.centerY.equalTo(self);
        make.right.equalTo(self.follow.mas_left).offset(-spacing);
        
    }];
    
    [self.follow mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-spacing);
        make.width.height.equalTo(@(followSize));
        
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-SINGLE_LINE_WIDTH);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    
}

- (void)follow:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    BOOL isfollow = !sender.selected;
    
    weakself(self);
    
    NSString *url = [NSString stringWithFormat:FollowComicsUrlStringFormat,self.model.ID.stringValue];
    
    [UserInfoManager followWithUrl:url isFollow:isfollow WithfollowCallBack:^(BOOL succeed) {
       
        if (succeed) {
            
            sender.selected = isfollow;
            
            weakSelf.model.is_favourite = isfollow;
        }
        
        sender.userInteractionEnabled = YES;
        
    }];
}




- (UIImageView *)authorIcon {
    if (!_authorIcon) {
        UIImageView *icon = [UIImageView new];
        [self addSubview:icon];
        
        icon.layer.cornerRadius = imageSize * 0.5;
        icon.layer.masksToBounds = YES;
        icon.layer.borderWidth = 1.0;
        icon.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        _authorIcon = icon;
    }
    return _authorIcon;
}

- (UILabel *)authorName {
    if (!_authorName) {
        
        UILabel *name = [UILabel new];
        [self addSubview:name];
        
        name.font = [UIFont systemFontOfSize:13];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = colorWithWhite(0.4);
        _authorName = name;
    }
    return _authorName;
}

- (UIButton *)follow {
    if (!_follow) {
        UIButton *btn = [UIButton new];
        [self addSubview:btn];
        
        [btn setImage:[UIImage imageNamed:@"ic_details_top_collection_normal_21x21_"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"ic_details_top_collection_prressed_21x21_"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        
        _follow = btn;
        
    }
    return _follow;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [UIView new];
        [self addSubview:line];
        
        line.backgroundColor = colorWithWhite(0.9);
        
        _line = line;
    }
    
    return _line;
}

@end
