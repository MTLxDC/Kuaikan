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

@interface AuthorInfoDetailHeadView ()

@property (weak, nonatomic) IBOutlet userAuthenticationIcon *authorIcon;

@property (weak, nonatomic) IBOutlet UILabel *authorName;

@property (weak, nonatomic) IBOutlet UILabel *authorSummary;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraints;

@end

@implementation AuthorInfoDetailHeadView

- (void)setModel:(AuthorInfoModel *)model {
    _model = model;

    [self.authorIcon updateIconWithImageUrl:model.avatar_url];
    
    self.authorName.text = model.nickname;
    self.authorSummary.text = model.intro;
     
}


static CGFloat iconTop  = 64;

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat offsetY = AuthorInfoDetailHeadViewHeight - self.height;
    
    BOOL isDragUp = offsetY > 0;
    
    /*
     
     navHeight = 64;
     statusbar = 20;
     
     64 - 20 * 0.5 = 22;    //得到导航条的中心
     22 + 8 = 30;           //8是标题label的一半高,得到目标X为30
     
     0.85 = 1 - 30/AuthorInfoDetailHeadViewHeight
     
     */
    
    CGFloat scale = isDragUp ? 0.85 : 0.43;

    CGFloat alpha = 1;
    
    if (isDragUp) {
        CGFloat prograss = offsetY/AuthorInfoDetailHeadViewHeight;
        alpha = 1 - prograss - 0.3;
    }
    
    self.authorIcon.alpha    = alpha;
    self.authorSummary.alpha = alpha;
    
    self.iconTopConstraints.constant = iconTop - offsetY * scale;
    
    [super layoutSubviews];

}


- (IBAction)back:(id)sender {
    
    UINavigationController *myNav = [self findResponderWithClass:[UINavigationController class]];
    
    [myNav popViewControllerAnimated:YES];
    
}

+ (instancetype)makeAuthorInfoDetailHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:@"AuthorInfoDetailHeadView" owner:nil options:nil] firstObject];
}


- (void)awakeFromNib {
        
}

@end
