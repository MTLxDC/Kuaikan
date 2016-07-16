//
//  GuanFangHuoDongCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import "GuanFangHuoDongCell.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>
#import "bannersModel.h"
#import "CartoonDetailViewController.h"

static CGFloat spaceing = 10;

@interface GuanFangHuoDongCellItem : UIView

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *label;

@end

@implementation GuanFangHuoDongCellItem


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelH = 15;
    CGFloat imageViewH = self.height - labelH - spaceing * 2;
    
    self.imageView.frame = CGRectMake(0, 0, self.width,imageViewH);
    self.label.frame = CGRectMake(0,CGRectGetMaxY(self.imageView.frame) + spaceing,
                                  self.width, labelH);
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:13];
        [self addSubview:_label];
    }
    return _label;
}

@end

@interface GuanFangHuoDongCell ()

@property (nonatomic,strong) GuanFangHuoDongCellItem *leftItem;

@property (nonatomic,strong) GuanFangHuoDongCellItem *rightItem;


@end

@implementation GuanFangHuoDongCell

- (void)setTopics:(NSArray *)topics {
    _topics = topics;
    
    UIImage *palceImage = [UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"];
    
    bannersModel *left  = [topics firstObject];
    bannersModel *right = [topics lastObject];

    
    [self.leftItem.imageView sd_setImageWithURL:[NSURL URLWithString:left.pic]
                               placeholderImage:palceImage];
    self.leftItem.label.text = left.target_title;
    
    [self.rightItem.imageView sd_setImageWithURL:[NSURL URLWithString:right.pic]
                               placeholderImage:palceImage];
    self.rightItem.label.text = right.target_title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemHeight = self.bounds.size.height - spaceing * 2;
    CGFloat itemWith = (self.width - 3 * spaceing) * 0.5;
    
    self.leftItem.frame = CGRectMake(spaceing, spaceing,itemWith, itemHeight);
    
    self.rightItem.frame = CGRectMake(itemWith + (2 * spaceing), spaceing,itemWith, itemHeight);

    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    NSInteger index = [[tap view] tag];
    
    bannersModel *md = [self.topics objectAtIndex:index];
    
    CartoonDetailViewController *cdvc = [CartoonDetailViewController new];
    
    cdvc.cartoonId = md.target_id;
    
    [[self findResponderWithClass:[UINavigationController class]] pushViewController:cdvc animated:YES];
    
}


- (GuanFangHuoDongCellItem *)leftItem {
    if (!_leftItem) {
        _leftItem = [GuanFangHuoDongCellItem new];
        _leftItem.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_leftItem addGestureRecognizer:tap];
        [self.contentView addSubview:_leftItem];
    }
    return _leftItem;
}

- (GuanFangHuoDongCellItem *)rightItem {
    if (!_rightItem) {
        _rightItem = [GuanFangHuoDongCellItem new];
        _rightItem.tag = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_rightItem addGestureRecognizer:tap];
        [self.contentView addSubview:_rightItem];
    }
    return _rightItem;
}

@end
