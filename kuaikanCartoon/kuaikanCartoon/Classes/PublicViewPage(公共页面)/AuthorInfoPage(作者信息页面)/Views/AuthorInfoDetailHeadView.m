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
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface AuthorInfoDetailHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *authorIcon;

@property (weak, nonatomic) IBOutlet UILabel *authorName;

@property (weak, nonatomic) IBOutlet UILabel *authorSummary;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraints;

@end

@implementation AuthorInfoDetailHeadView

- (void)setModel:(AuthorInfoModel *)model {
    _model = model;

    [self.authorIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar_url]      placeholderImage:[UIImage imageNamed:@"ic_author_info_headportrait_50x50_"]];
    
    self.authorName.text = model.nickname;
    self.authorSummary.text = model.intro;
     
}


static CGFloat iconTop = 64;

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat offsetY = AuthorInfoDetailHeadViewHeight - self.height;
    
    BOOL isDragUp = offsetY > 0;
    
    CGFloat scale = isDragUp ? 0.86 : 0.43;

    CGFloat alpha = 1;
    
    if (isDragUp) {
        alpha = 1 - (offsetY + 64)/AuthorInfoDetailHeadViewHeight;
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
    
    [self.authorIcon cornerRadius:0];
    
}

@end
