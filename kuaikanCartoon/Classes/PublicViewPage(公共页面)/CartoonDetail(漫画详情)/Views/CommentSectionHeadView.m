//
//  CommentSectionHeadView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/28.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentSectionHeadView.h"
#import <Masonry.h>
#import "CommonMacro.h"

static const CGFloat spaceing = 8.0f;
static const CGFloat contentHeight = 20.0f;


@interface CommentSectionHeadView ()

@property (nonatomic,weak) UILabel *titleView;


@end

@implementation CommentSectionHeadView


- (void)setText:(NSString *)text {
    self.titleView.text = text;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    CGFloat w = 5;
    
    UIView *yellowView = [[UIView alloc] init];
    
    yellowView.backgroundColor = subjectColor;
    yellowView.layer.cornerRadius  = w * 0.5;
    yellowView.layer.masksToBounds = YES;
    
    [self addSubview:yellowView];
    
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(spaceing);
        make.height.equalTo(@(contentHeight));
        make.width.equalTo(@(w));
    }];
    
    
    UILabel *titleView = [[UILabel alloc] init];
    
    titleView.font = [UIFont systemFontOfSize:15];
    titleView.textColor = [UIColor darkGrayColor];
    titleView.text = @"热门评论";
    
    [self addSubview:titleView];
    
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(yellowView.mas_right).offset(spaceing * 0.5);
        make.height.equalTo(@(contentHeight));
    }];
    
    self.titleView = titleView;
}

@end
