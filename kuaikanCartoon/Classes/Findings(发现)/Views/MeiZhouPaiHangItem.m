//
//  MeiZhouPaiHangItem.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/10.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MeiZhouPaiHangItem.h"
#import "topicModel.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface MeiZhouPaiHangItem ()

@property (weak, nonatomic) IBOutlet UIImageView *topicImage;

@property (weak, nonatomic) IBOutlet UILabel *rankingNuber;
@property (weak, nonatomic) IBOutlet UILabel *topicName;

@property (weak, nonatomic) IBOutlet UILabel *topicAuthorName;


@property (nonatomic,weak) UIView *topLine;
@property (nonatomic,weak) UIView *bottomLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;


@end

@implementation MeiZhouPaiHangItem

- (void)setRankingNumber:(NSInteger)rankingNumber {
    _rankingNumber = rankingNumber;
    
    self.rankingNuber.text = [NSString stringWithFormat:@"%zd",rankingNumber];
}

- (void)setModel:(topicModel *)model {
    _model = model;
    
    [self.topicImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]
                       placeholderImage:[UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"]];
    
    self.topicName.text = model.title;
    self.topicAuthorName.text = model.user.nickname;
    
}

+ (instancetype)makeMeiZhouPaiHangItem {
    return [[[NSBundle mainBundle] loadNibNamed:@"MeiZhouPaiHangItem" owner:nil options:nil] firstObject];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageViewWidth.constant = CGRectGetWidth(self.frame) * 0.4;
    
    [super layoutSubviews];
}

- (void)setHideLine:(BOOL)hideLine {
    
    self.topLine.hidden = hideLine;
    self.bottomLine.hidden = hideLine;
    
}

- (void)awakeFromNib {
    
    self.topLine = [self addSpaceingLine];
    self.bottomLine = [self addSpaceingLine];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}


- (UIView *)addSpaceingLine {
    
    UIView *line = [UIView new];
    
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self addSubview:line];
    
    return line;
}


@end
