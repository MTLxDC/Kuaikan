//
//  wordDescSectionHeadView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/19.
//  Copyright © 2016年 name. All rights reserved.
//

#import "wordDescSectionHeadView.h"
#import <Masonry.h>
#import "UIView+Extension.h"
#import "CommonMacro.h"

@interface wordDescSectionHeadView ()

@property (nonatomic,weak) UILabel  *descLabel;

@property (nonatomic,weak) UIButton *openUpBtn;

@property (nonatomic,assign) CGFloat textHeight;

@end

static CGFloat const spaceing    = 8;
static CGFloat const tbSpaceing = 12;


@implementation wordDescSectionHeadView

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    self.descLabel.text = desc;
    
    if (self.textHeight > self.descLabel.font.lineHeight * 2) {
            
        [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(-tbSpaceing * 2);
        }];
            
        [self openUpBtn];
    }

}

- (CGFloat)myHeight {

    [self setNeedsLayout];
    [self layoutIfNeeded];

    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (CGFloat)getDescTextHeight {
    
    CGSize maxSize = CGSizeMake(self.width - spaceing * 2,self.height * 2);
    
    return  [self.descLabel.text boundingRectWithSize:maxSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:self.descLabel.font}
                                            context:nil].size.height;
}

- (void)openOrClose:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    if (self.needReloadHeight) {
        self.descLabel.numberOfLines = btn.selected ? 0 : 2;
        self.needReloadHeight();
    }
    
}

- (void)setupUI {
    
    UILabel *descLabel = [UILabel new];
    
    descLabel.numberOfLines = 2;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - spaceing * 2;
    
    [self addSubview:descLabel];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(spaceing);
        make.top.equalTo(self).offset(tbSpaceing);
        make.right.equalTo(self).offset(-spaceing);
        make.bottom.equalTo(self).offset(-tbSpaceing);
    }];
    
    self.descLabel = descLabel;

    UIView *bottomLine = [UIView new];
    
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
}

- (CGFloat)textHeight {
    if (_textHeight < 1) {
        _textHeight = [self getDescTextHeight];
    }
    return _textHeight;
}

- (UIButton *)openUpBtn {
    if (!_openUpBtn) {
        
        UIButton *openUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        openUpBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        openUpBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        openUpBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        
        [openUpBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [openUpBtn setTitle:@"全部" forState:UIControlStateNormal];
        [openUpBtn setTitle:@"收起" forState:UIControlStateSelected];
        
        [openUpBtn setImage:[UIImage imageNamed:@"ic_album_open_7x4_"]  forState:UIControlStateNormal];
        [openUpBtn setImage:[UIImage imageNamed:@"ic_album_close_7x4_"] forState:UIControlStateSelected];
        
        [openUpBtn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:openUpBtn];
        
        [openUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-tbSpaceing);
            make.bottom.equalTo(self).offset(-spaceing);
            make.width.equalTo(@40);
            make.height.equalTo(@12);
        }];
        
        _openUpBtn = openUpBtn;
    }
    
    return _openUpBtn;
}
@end
