//
//  AuthorTopicInfoCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/17.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorTopicInfoCell.h"
#import "CommonMacro.h"
#import <Masonry.h>
#import "topicModel.h"
#import <UIImageView+WebCache.h>

@interface AuthorTopicInfoCell ()

@property (nonatomic,weak) UIImageView *topicImage;

@property (nonatomic,weak) UILabel *topicTitle;

@property (nonatomic,weak) UILabel *topicDesc;

@end

@implementation AuthorTopicInfoCell


- (void)setModel:(topicModel *)model {
    _model = model;
    
    [self.topicImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:placeImage_comic];
    
    self.topicTitle.text = model.title;
    self.topicDesc.text  = model.desc;
    
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
    
    CGFloat spaceing = 8;
    CGFloat imageWidth = SCREEN_WIDTH - spaceing * 2;

    UIImageView *topicImage = [UIImageView new];
    
    [self.contentView addSubview:topicImage];
    
    [topicImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(spaceing);
        make.bottom.equalTo(self.contentView).offset(-spaceing);
        make.width.equalTo(@(imageWidth * 0.33));
    }];
    
    self.topicImage = topicImage;
    
    
    UILabel *topicTitle = [UILabel new];
    
    topicTitle.font      = [UIFont systemFontOfSize:13];
    topicTitle.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:topicTitle];
    
    [topicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topicImage.mas_right).offset(spaceing);
        make.top.equalTo(topicImage);
        make.right.equalTo(self.contentView).offset(-spaceing);
        make.height.equalTo(@13);
    }];
    
    self.topicTitle = topicTitle;
    
    UILabel *topicDesc = [UILabel new];
    
    topicDesc.font      = [UIFont systemFontOfSize:11];
    topicDesc.textColor = colorWithWhite(0.6);
    topicDesc.numberOfLines = 3;
    
    [self.contentView addSubview:topicDesc];
    
    [topicDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topicTitle);
        make.top.equalTo(topicTitle.mas_bottom).offset(spaceing);
        make.bottom.equalTo(topicImage);
    }];
    
    self.topicDesc = topicDesc;
    
    UIView *topSpaceLine =  [UIView new];
    
    topSpaceLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.contentView addSubview:topSpaceLine];
    
    [topSpaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topicImage);
        make.top.right.equalTo(self.contentView);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
}

@end
