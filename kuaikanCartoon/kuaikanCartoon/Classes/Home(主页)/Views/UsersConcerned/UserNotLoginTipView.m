//
//  UserNotLoginTipView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/29.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UserNotLoginTipView.h"

@interface UserNotLoginTipView ()


@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnWidth;

@end

@implementation UserNotLoginTipView

- (void)setTip:(tipOption)tip {
    if (tip == tipOptionNotLogin) {
        
        self.tipLabel.text = @"没登录,超多精彩内容看不鸟";
        
        [self setLoginBtnImageWithName:@"ic_home_empty_login_normal_120x49_" pressName:@"ic_home_empty_login_pressed_120x49_"];
 
        self.loginBtnWidth.constant = 0;
        
    }else if (tip == tipOptionNotConcerned) {
        
        self.tipLabel.text = @"你还没有关注哦";
        
        [self setLoginBtnImageWithName:@"ic_home_empty_random_normal_150x49_" pressName:@"ic_home_empty_random_pressed_150x49_"];
        
        self.loginBtnWidth.constant = 30;
    }
    
    [self layoutIfNeeded];
}


- (void)setLoginBtnImageWithName:(NSString *)name pressName:(NSString *)pressName{
    
    [self.loginBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self.loginBtn setImage:[UIImage imageNamed:pressName] forState:UIControlStateHighlighted];
}

+ (instancetype)makeUserNotLoginTipView {
    return [[[NSBundle mainBundle] loadNibNamed:@"UserNotLoginTipView" owner:nil options:nil] firstObject];
}

- (IBAction)login:(id)sender {
    if (self.loginOnClick) {
        self.loginOnClick(self);
    }
}

@end
