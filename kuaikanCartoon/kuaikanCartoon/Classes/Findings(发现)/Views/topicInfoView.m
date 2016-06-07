//
//  topicInfoView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import "topicInfoView.h"
#import "topicModel.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>

@interface topicInfoView ()

@property (nonatomic,weak) UIImageView *imageView;

@property (nonatomic,weak) UIImageView *maskView;

@property (nonatomic,weak) UILabel *titleLabel;

@end


@implementation topicInfoView



+ (void)jiuGongGeLayout:(NSArray<topicInfoView *> *)views WithMaxWidth:(CGFloat)maxWidth WithRow:(NSInteger)row {
    
    NSInteger itemCount = 3;
    
    CGFloat itemWidth = (maxWidth - (itemCount + 1) * spaceing)/itemCount;
    
    CGFloat y,x;
    
    for (NSInteger section = 0; section < row; section++) {
        
        y = section *  (itemHeight + spaceing) + spaceing;
        
        for (NSInteger index = 0; index < itemCount; index++) {
            
            x = index *  (itemWidth + spaceing) + spaceing;
            
            [views[index + itemCount * section] setFrame:CGRectMake(x, y, itemWidth, itemHeight)];
            
        }
    }

    
    
}

- (void)setModel:(topicModel *)model {
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]
                      placeholderImage:[UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"]];
    
    self.titleLabel.text = model.title;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maskH  = 30;
    CGFloat labelH = 20;
    
    self.imageView.frame = self.bounds;
    self.maskView.frame = CGRectMake(0,self.height - maskH,self.width, maskH);
    self.titleLabel.frame = CGRectMake(5,self.height - labelH,self.width - 10, labelH);
    
}

- (void)setupUI {
    
    UIImageView *imageView = [UIImageView new];

    [self addSubview:imageView];
    
    self.imageView = imageView;
    
    UIImageView *maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_album_mask_1x40_"]];
    
    [self addSubview:maskView];
    
    self.maskView = maskView;
    
    UILabel *label = [UILabel new];
    
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    
    [self addSubview:label];
    
    self.titleLabel = label;
}

@end
