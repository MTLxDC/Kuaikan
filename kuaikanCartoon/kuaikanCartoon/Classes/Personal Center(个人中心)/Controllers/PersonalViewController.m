//
//  PersonalViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "PersonalViewController.h"
#import <UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "UserInfoManager.h"
#import "UIView+Extension.h"

@interface PersonalViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (nonatomic,strong) UserInfoManager *user;

@end


@implementation PersonalViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userIcon cornerRadius:0];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (self.user.hasLogin) {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.user.icon_url]];
        self.userName.text = self.user.nickname;
    }else {
        self.userName.text = @"登录";
    }
  
    
}

- (IBAction)needLogin:(id)sender {
    
    if (self.user.hasLogin) {
        return;
    }
    
    LoginViewController *lvc = [LoginViewController new];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];

    [self presentViewController:nav animated:YES completion:nil];
}


- (UserInfoManager *)user {
    if (!_user) {
        _user = [UserInfoManager share];
    }
    return _user;
}

@end
