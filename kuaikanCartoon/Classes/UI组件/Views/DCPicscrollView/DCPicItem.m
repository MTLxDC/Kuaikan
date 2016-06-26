//
//  DCPicItem.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//

#import "DCPicItem.h"
#import "UIImageView+WebCache.h"

@interface DCPicItem ()
{
    @private
    
   __weak UIImageView * _imageView;
   __weak UILabel     * _titleView;
    
    DCPicItemConfiguration *_configuration;

}

@property (nonatomic,weak) UIImageView *bottomView;


@end

@implementation DCPicItem

- (void)setConfiguration:(DCPicItemConfiguration *)configuration {
    if (self.configuration) return;
    _configuration = configuration;
    
    self.imageView.contentMode = configuration.contentMode;
    
    if (self.imageView.image == nil) {
        self.imageView.image = configuration.placeImage;
    }
    
    if (!self.configuration.showBottomView) return;
    
    self.titleView.textColor = configuration.textColor;
    self.titleView.font = configuration.textFont;
    
    self.bottomView.backgroundColor = configuration.bgColor;
    self.bottomView.image = configuration.bgImage;

}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    BOOL show = self.configuration.showBottomView;
    
    if (show) {
        CGFloat h =  self.configuration.bottomViewHeight;
        CGFloat y = self.bounds.size.height - h;
        
        self.bottomView.frame = CGRectMake(0,y,self.bounds.size.width, h);
        self.titleView.frame = self.bottomView.bounds;
        
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.clipsToBounds = YES;
        [self.contentView addSubview:iv];
        _imageView = iv;
    }
    return _imageView;
}

- (UILabel *)titleView {
    if (!_titleView) {
        UILabel *tv = [[UILabel alloc] init];
        tv.textAlignment = NSTextAlignmentLeft;
        tv.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.bottomView addSubview:tv];
        _titleView = tv;
    }
    return _titleView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIImageView *bv = [[UIImageView alloc] init];
        bv.contentMode = UIViewContentModeScaleAspectFill;
        bv.clipsToBounds = YES;
        [self.contentView addSubview:bv];
        _bottomView = bv;
    }
    return _bottomView;
}


@end
