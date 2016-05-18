//
//  likeCountView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "likeCountView.h"
#import "NetWorkManager.h"
#import "Color.h"
#import "CommonMacro.h"

static NSString * const likeUrl = @"http://api.kuaikanmanhua.com/v1/comics";

static NSString * const normalImageName = @"ic_common_praise_normal_15x15_";
static NSString * const pressedImageName = @"ic_details_toolbar_praise_pressed_21x21_";


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
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,5, 0, 0)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.islike = false;
}

- (void)setIslike:(BOOL)islike {
    _islike = islike;
    
    NSString *imageName = self.islike ? pressedImageName : normalImageName;
    
    [self setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UIColor *textColor = self.islike ? subjectColor : [UIColor lightGrayColor];
    
    [self setTitleColor:textColor forState:UIControlStateNormal];
    

}

- (void)setLikeCount:(NSUInteger)likeCount {
    _likeCount = likeCount;
    if (likeCount < 1) {
        [self setTitle:nil forState:UIControlStateNormal];
        return;
    }
    [self setTitle:[self makeTextWithCount:likeCount] forState:UIControlStateNormal];
}

- (void)like {
    
    self.userInteractionEnabled = NO;
    
    self.islike = !self.islike;
    
    self.likeCount += (self.islike ? 1 : -1);
    
    [self setTitle:[self makeTextWithCount:self.likeCount] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:10.0f options:0 animations:^{
        
        self.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
            self.userInteractionEnabled = YES;
        }];
        
    }];
    
    
    NetWorkManager *manger = [NetWorkManager share];
    
    NSArray *parameter  = self.islike ? @[@"POST",@"/like"] : @[@"DELETE",@"/like?"];   //取消赞DELETE,反则POST
    
    NSMutableString *newUrl = [likeUrl mutableCopy];
    
    [newUrl appendFormat:@"/%@%@",self.requestID,parameter.lastObject];
    
    [manger requestWithMethod:parameter.firstObject url:newUrl parameters:nil complish:^(id res, NSError *error) {
        if (error == nil) {
            DEBUG_Log(@"%@",res);
        }
    }];
    
}


- (NSString *)makeTextWithCount:(NSInteger)count {
    
    NSString *topCountText = nil;
    
    if (count >= 100000) {
        topCountText = [NSString stringWithFormat:@"%zd万",count/10000];
    }else {
        topCountText = [NSString stringWithFormat:@"%zd",count];
    }
    
    return topCountText;
}


@end
