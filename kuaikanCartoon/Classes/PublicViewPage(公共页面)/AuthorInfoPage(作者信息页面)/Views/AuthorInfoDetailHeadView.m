//
//  AuthorInfoHeadView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/17.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorInfoDetailHeadView.h"
#import "UIView+Extension.h"
#import "AuthorInfoModel.h"
#import <Masonry.h>
#import "UIImageView+Extension.h"
#import "userAuthenticationIcon.h"
#import "UserInfoManager.h"
#import "NSString+Extension.h"

@interface AuthorInfoDetailHeadView () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet userAuthenticationIcon *authorIcon;

@property (weak, nonatomic) IBOutlet UILabel *authorName;

@property (weak, nonatomic) IBOutlet UILabel *authorSummary;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UILabel *fansNumber;

@property (nonatomic,assign) BOOL isFollow;
@property (nonatomic,assign) CGFloat authorSummaryTextHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fansNumberWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorSummaryHeight;


@end

@implementation AuthorInfoDetailHeadView

- (void)setModel:(AuthorInfoModel *)model {
    _model = model;
    
    self.authorName.text    = model.nickname;
    self.authorSummary.text = model.u_intro;
    self.followBtn.selected = model.following;
    
    NSString *text = [NSString stringWithFormat:@"%@ 粉丝",model.follower_cnt];
    
    CGFloat width  = [text getTextWidthWithFont:self.fansNumber.font
                                                             WithMaxSize:CGSizeMake(self.width * 0.8,15)] + 20;
     self.fansNumberWidth.constant = width;
    [self.fansNumber setText:text];
    
    self.authorSummaryTextHeight = [model.u_intro boundingRectWithSize:CGSizeMake(self.authorSummary.preferredMaxLayoutWidth,self.height) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.authorSummary.font} context:nil].size.height + 3;

    [self.authorIcon updateIconWithImageUrl:model.avatar_url];

    [self.fansNumber setNeedsLayout];
    [self setNeedsLayout];
}


static CGFloat iconTop  = 64;

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat offsetY = AuthorInfoDetailHeadViewHeight - self.height;
    
    BOOL isDragUp = offsetY > 0;
    
    /*
     
     navHeight = 64;
     statusbar = 20;
     
     0.85 = 1 - 30/AuthorInfoDetailHeadViewHeight
     
     16 80 18
     */
    
    CGFloat alpha = 1;
    CGFloat prograss = offsetY/(AuthorInfoDetailHeadViewHeight - 64);

    if (isDragUp) {
        alpha = 1 - prograss - 0.3;
    }
    
    self.authorIcon.alpha    = alpha;
    self.authorSummary.alpha = alpha;
    self.fansNumber.alpha    = alpha;
    
    self.authorSummary.preferredMaxLayoutWidth = CGRectGetWidth(self.authorSummary.frame);
    
    CGFloat realityMaxY = self.authorSummary.y + self.authorSummaryTextHeight;
    CGFloat newHeight   = self.authorSummaryTextHeight;
    
    if (realityMaxY > self.height) newHeight = self.height - self.authorSummary.y;
    
    self.iconTopConstraints.constant  = iconTop - prograss * 115;
    self.authorSummaryHeight.constant = newHeight < 15 ? 15 : newHeight;
    
    [super layoutSubviews];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.isFollow = NO;
    }
}

- (void)setIsFollow:(BOOL)isFollow {
    _isFollow = isFollow;
    
    self.followBtn.userInteractionEnabled = NO;
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/update_following_author?author_id=%@&relation=%d&uid=%@",self.model.ID,isFollow,[UserInfoManager share].ID];
    
    __weak AuthorInfoDetailHeadView *wself = self;
    
    [UserInfoManager followWithUrl:url isFollow:isFollow WithfollowCallBack:^(BOOL succeed) {
        
        if (succeed) wself.followBtn.selected = !wself.followBtn.selected;
        
        wself.followBtn.userInteractionEnabled = YES;
    }];
    
}

- (IBAction)follow:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.selected) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"不要抛下我!\no(>﹏<)o"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"狠心抛弃", nil];
        [alert show];
        
    }else {
        
        self.isFollow = YES;
        
    }
    
}

- (IBAction)back:(id)sender {
    [self.myViewController.navigationController popViewControllerAnimated:YES];
    
}

+ (instancetype)makeAuthorInfoDetailHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:@"AuthorInfoDetailHeadView" owner:nil options:nil] firstObject];
}


- (void)awakeFromNib {
     self.fansNumber.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.fansNumber cornerRadius:8];
}

@end
