//
//  likeCountView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "likeCountView.h"
#import "NetWorkManager.h"
#import "CommonMacro.h"
#import "NSString+Extension.h"
#import "UIView+Extension.h"
#import <Masonry.h>

static NSString * const likeUrl = @"http://api.kuaikanmanhua.com/v1/comics";

static NSString * const normalImageName = @"ic_common_praise_normal_15x15_";
static NSString * const pressedImageName = @"ic_common_praise_pressed_15x15_";

#define MyWidth 30.0f

@implementation likeCountView

+ (instancetype)likeCountViewWithCount:(NSInteger)count requestID:(NSString *)ID {
    
    likeCountView *like = [[likeCountView alloc] init];
    like.likeCount = count;
    like.requestID = ID;
    
    return like;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self setup];
    
}

- (void)setup {

    [self addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,8, 0, 0)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.islike = false;
}

- (void)setIslike:(BOOL)islike {
    _islike = islike;
    
    int upCount = islike ? 1 : -1;
    
    self.likeCount = self.likeCount + upCount;
    
    NSString *imageName = self.islike ? pressedImageName : normalImageName;
    
    [self setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UIColor *textColor = self.islike ? subjectColor : [UIColor lightGrayColor];
    
    [self setTitleColor:textColor forState:UIControlStateNormal];

}



- (void)setLikeCount:(NSInteger)likeCount {
    _likeCount = likeCount;
    
    CGFloat width = MyWidth;
    
    if (likeCount < 1) {
        
       [self setTitle:nil forState:UIControlStateNormal];
        
    }else {
        
        NSString *title = [NSString makeTextWithCount:likeCount];
        
        [self setTitle:title forState:UIControlStateNormal];
        
        width = [title getTextWidthWithFont:self.titleLabel.font] + MyWidth;

    }
    
    if (self.translatesAutoresizingMaskIntoConstraints) {
        [self setWidth:width];
    }else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
        }];
    }
    
}

- (void)like {
    
    self.userInteractionEnabled = NO;
    
    self.islike = !self.islike;
    
    if (self.onClick) {
        self.onClick(self);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
            self.userInteractionEnabled = YES;
        }];
        
    }];
    
    
//    NetWorkManager *manger = [NetWorkManager share];
//
//    NSArray *parameter  = self.islike ? @[@"POST",@"/like"] : @[@"DELETE",@"/like?"];   //取消赞DELETE,反则POST
//    
//    NSMutableString *newUrl = [likeUrl mutableCopy];
//    
//    [newUrl appendFormat:@"/%@%@",self.requestID,parameter.lastObject];
//    
//    [manger requestWithMethod:parameter.firstObject url:newUrl.copy parameters:nil complish:^(id res, NSError *error) {
//            DEBUG_Log(@"%@",error);
//    }];
    
}



@end
