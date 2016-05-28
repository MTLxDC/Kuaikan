//
//  LoginViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/23.
//  Copyright © 2016年 name. All rights reserved.
//

#import "LoginViewController.h"
#import "Color.h"
#import "UIView+Extension.h"
#import "ProgressHUD.h"
#import "NetWorkManager.h"
#import "UserInfoManager.h"
#import "NSString+Extension.h"
#import "registerViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *loginIcon;

@property (weak, nonatomic) IBOutlet UIButton *loginUserIcon;

@property (weak, nonatomic) IBOutlet UIButton *loginPasswordIcon;

@property (weak, nonatomic) IBOutlet UITextField *userInputView;
@property (weak, nonatomic) IBOutlet UITextField *passwordInputView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *DividingLine;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewCenterY;


@property (nonatomic,strong) registerViewController *registerVc;

@end


static NSString * const signinBaseUrlString = @"http://api.kuaikanmanhua.com/v1/phone/signin";


@implementation LoginViewController

- (instancetype)init
{
    if ([UserInfoManager share].hasLogin) return nil;
    
    return [super initWithNibName:@"LoginViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = subjectColor;
    
    self.loginBtn.backgroundColor = RGB(32, 40, 48);
    self.DividingLine.backgroundColor = White(0.9);
    
    [self.loginBtn cornerRadius:10];
    [self.inputView cornerRadius:10];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)loginBtnEnabledIfNeed {
    
    self.loginBtn.enabled = self.userInputView.text.length > 0 &&
                            self.passwordInputView.text.length > 0;
}

//{
//    "code": 200,
//    "data": {
//        "avatar_url": "http://i.kuaikanmanhua.com/default_avatar_image.jpg-w180",
//        "grade": 0,
//        "id": 13124241,
//        "nickname": "NSDengChen",
//        "reg_type": "phone",
//        "update_remind_flag": 1
//    },
//    "message": "OK"
//}

//登录
- (IBAction)login:(id)sender {
    
    if (![self canLogin]) return;
    
    dissmissCallBack dissMiss = [ProgressHUD showProgressWithStatus:@"登录中..."
                                                             inView:self.view];
    
    NetWorkManager *manager = [NetWorkManager share];
    
    NSDictionary *parameters = @{@"password":self.passwordInputView.text,
                                 @"phone":self.userInputView.text,};
    
    [manager requestWithMethod:@"POST" url:signinBaseUrlString parameters:parameters complish:^(id res, NSError *error) {
        
        dissMiss();
        
        if (error != nil) {
            
            [ProgressHUD showErrorWithStatus:@"网络出了点小问题" inView:self.view];
            
            return ;
        }

        NSDictionary *result = (NSDictionary *)res;
        
        NSString *message  = result[@"message"];
        NSDictionary *data = result[@"data"];

        if ([message isEqualToString:@"OK"] && data) {
            
         UserInfoManager *user = [UserInfoManager share];
            
            user.hasLogin = YES;
            user.icon_url = data[@"avatar_url"];
            user.ID = data[@"id"];
            user.nickname = data[@"nickname"];
            user.reg_type = data[@"reg_type"];
            user.update_remind_flag = data[@"update_remind_flag"];
            
            [ProgressHUD showSuccessWithStatus:@"登录成功" inView:self.view];
            
            if (self.loginSucceeded) {
                self.loginSucceeded(user);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else {
            
            [ProgressHUD showErrorWithStatus:@"用户名或密码不正确" inView:self.view];
            
        }
        
    }];
    
    
}

- (BOOL)canLogin {
    
    if (self.passwordInputView.text.length < 8) {
        [ProgressHUD showErrorWithStatus:@"密码长度至少为8位" inView:self.view];
        return NO;
    }
    
    if (!self.userInputView.text.isMobile) {
        [ProgressHUD showErrorWithStatus:@"你输入的手机号无效,请重新输入" inView:self.view];
        return NO;
    }
    
    return YES;
}



//注册
- (IBAction)registered:(id)sender {
    
    [self.navigationController pushViewController:self.registerVc animated:YES];
    
}

//忘记密码
- (IBAction)forgetPassword:(UITextField *)sender {
}

//用户名开始编辑
- (IBAction)userEditBegin:(UITextField *)sender {
    self.loginIcon.highlighted = NO;
    self.loginUserIcon.highlighted = YES;
    
    
}

//用户编辑发生改动
- (IBAction)userEditChange:(UITextField *)sender {
    [self loginBtnEnabledIfNeed];
    
}
- (IBAction)userEditEnd:(UITextField *)sender {
    self.loginUserIcon.highlighted = NO;
    
    
}

//用户名开始编辑
- (IBAction)passwordEditBegin:(UITextField *)sender {
    self.loginIcon.highlighted = YES;
    self.loginPasswordIcon.highlighted = YES;
    
    
}

//用户编辑发生改动

- (IBAction)passwordEditChange:(UITextField *)sender {
    [self loginBtnEnabledIfNeed];
    
}
- (IBAction)passwordEditEnd:(UITextField *)sender {
    self.loginPasswordIcon.highlighted = NO;
    
}

//回家
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (registerViewController *)registerVc {
    if (!_registerVc) {
        _registerVc = [registerViewController new];
    }
    return _registerVc;
}

@end
