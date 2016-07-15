//
//  AuthorShareInfoCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/18.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorShareInfoCell.h"
#import <Masonry.h>
#import "AuthorInfoModel.h"
#import "CommonMacro.h"

@interface AuthorShareInfoCell ()

@property (nonatomic,weak) UIImageView *iconView;

@property (nonatomic,weak) UILabel *titleView;

@property (nonatomic,weak) UILabel *tipView;

@end


@implementation AuthorShareInfoCell

//1.微博 //2.微信 //3.一个主页链接 //4.appstore下载应用的链接

- (void)setText:(NSString *)text atIndex:(NSInteger)index {
    _text = text;

    NSString *iconName = nil;
    NSString *tip = nil;
    UIColor  *textColor = nil;
    
    switch (index)
    {
        case 0:
        {
             iconName  = @"ic_author_info_weibo_22x22_";
             tip       = @"点击复制";
             textColor = RGB(207, 98, 96);
        }
            break;
        case 1:
        {
            iconName  = @"ic_author_info_wechat_22x22_";
            tip       = @"点击复制";
            textColor = RGB(78, 158, 11);
        }
            break;
        case 2:
        {
            iconName  = @"ic_author_info_link_22x22_";
            tip       = @"访问网站";
            textColor = RGB(86, 149, 177);
        }
            break;
        case 3:
        {
            iconName  = @"ic_author_info_download_22x22_";
            textColor = [UIColor darkGrayColor];
        }
            break;
            
        default:
            break;
    }
    
    self.iconView.image = [UIImage imageNamed:iconName];
    self.titleView.text = index != 3 ? text : @"下载应用";
    self.titleView.textColor = textColor;
    self.tipView.text = tip;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}



- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat spaceing = SPACEING;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(spaceing);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@22);
    }];
    
    self.iconView = iconView;
    
    UILabel *tipView = [[UILabel alloc] init];
    
    tipView.font      = [UIFont systemFontOfSize:12];
    tipView.textColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-spaceing);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@15);
    }];
    
    self.tipView = tipView;
    
    UILabel *titleView = [[UILabel alloc] init];
    
    titleView.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(spaceing);
        make.right.equalTo(self.tipView).offset(-spaceing);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@15);
    }];
    
    self.titleView = titleView;
    
    UIView *spaceLine = [[UIView alloc] init];
    
    spaceLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.contentView addSubview:spaceLine];
    
    [spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(spaceing);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
}

@end
