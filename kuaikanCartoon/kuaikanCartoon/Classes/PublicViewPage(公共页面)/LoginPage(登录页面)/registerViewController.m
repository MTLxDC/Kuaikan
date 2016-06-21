//
//  registerViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/25.
//  Copyright © 2016年 name. All rights reserved.
//

#import "registerViewController.h"
#import "UIView+Extension.h"
#import "NetWorkManager.h"
#import "NSString+Extension.h"
#import "ProgressHUD.h"
#import "CommonMacro.h"

@interface registerViewController ()

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSMSCode;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIView *SMSCodeInputView;
@property (weak, nonatomic) IBOutlet UITextField *SMSCodeTextField;

@property (nonatomic,assign) BOOL registerToStart;

@end

static NSString * const send_code = @"http://api.kuaikanmanhua.com/v1/phone/send_code";


@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = subjectColor;
    self.nextStepBtn.backgroundColor = RGB(32, 40, 48);

    [self.SMSCodeInputView cornerRadius:10];
    [self.inputView cornerRadius:10];
    [self.nextStepBtn cornerRadius:10];
    
    [self.phoneTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)phoneTextFieldBeginEditing:(id)sender {
    self.phoneIcon.highlighted = YES;
}
- (IBAction)phoneTextFieldEndEditing:(id)sender {
    self.phoneIcon.highlighted = NO;
}
- (IBAction)phoneTextFieldChange:(id)sender {
 
}

- (IBAction)SMSCodeTextChange:(UITextField *)sender {
    if (self.registerToStart) {
        self.nextStepBtn.enabled = sender.text.length;
    }
}

- (IBAction)getSMSCode:(id)sender {
    
    if (!self.phoneTextField.text.isMobile) {
        [ProgressHUD showErrorWithStatus:@"你输入的手机号无效,请重新输入" inView:self.view];
        return;
    }

 dissmissCallBack dissmiss = [ProgressHUD showProgressWithStatus:@"稍等片刻..." inView:self.view];
    
    NetWorkManager *manager = [NetWorkManager share];
    
    NSDictionary *parameters = @{@"phone":self.phoneTextField.text,
                                 @"reason":@"register"};
    
    [manager requestWithMethod:@"POST" url:send_code parameters:parameters complish:^(id res, NSError *error) {
        
        if (error != nil) {
        [ProgressHUD showErrorWithStatus:@"网络超时\n(╯°Д°)╯︵ ┻━┻ " inView:self.view];
            return ;
        }
        
        dissmiss();
        
        NSDictionary *result = (NSDictionary *)res;
        
        NSNumber *code = result[@"code"];
        NSString *message = result[@"message"];
        
        if ([message isEqualToString:@"OK"]) {
            
            self.registerToStart = YES;
            
            [self SMSCodeTextChange:self.SMSCodeTextField];
            
            [self startTiming];
            
        }else if (code.integerValue == 600003) {
            
            [ProgressHUD showErrorWithStatus:@"手机号已经被注册了\n(╯°Д°)╯︵ ┻━┻ " inView:self.view];
            
        }else if (code.integerValue == 600014) {
            
            [ProgressHUD showErrorWithStatus:@"操作太频繁\n(╯°Д°)╯︵ ┻━┻ " inView:self.view];

        }
        
    }];
    
    
}

- (void)dealloc {

}

-(void)startTiming{
    
    __block int timeout = 30; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(timer, ^{
        
        if(timeout <= 0){   //倒计时结束，关闭
            
                //设置界面的按钮显示 根据自己需求设置
                [self.getSMSCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.getSMSCode.userInteractionEnabled = YES;
            
            dispatch_source_cancel(timer);

        }else{
            
            [self.getSMSCode setTitle:[NSString stringWithFormat:@"%d秒后重新发送",timeout] forState:UIControlStateNormal];
            self.getSMSCode.userInteractionEnabled = NO;
            
            timeout--;
        }
    });
    dispatch_resume(timer);

}


- (IBAction)nextStep:(id)sender {
    
    NSString *url = @"http://api.kuaikanmanhua.com/v1/phone/verify";
    
    weakself(self);
    
    [[NetWorkManager share] requestWithMethod:@"POST" url:url parameters:@{@"code":self.SMSCodeTextField.text,@"phone":self.phoneTextField.text} complish:^(id res, NSError *error) {
        
        NSDictionary *result = (NSDictionary *)res;
        
        NSNumber *code = result[NetCode];
        NSString *message = result[NetMessage];
        
        if ([message isEqualToString:@"OK"]) {
            
            [ProgressHUD showSuccessWithStatus:@"注册成功" inView:weakSelf.view];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            
            NSString *errorStatus = nil;
            
            switch (code.integerValue) {
                case 600005: errorStatus = @"验证码无效或者过期咯"; break;
                    
                default:{
                    errorStatus = @"未知错误";
                    DEBUG_Log(@"%@",error.userInfo);
                    break;
                }
            }
            
            [ProgressHUD showErrorWithStatus:errorStatus inView:weakSelf.view];
        }
        
    }];
    
    
}

- (IBAction)viewUserAgreement:(id)sender {
    
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (instancetype)init
{
    return [super initWithNibName:@"registerViewController" bundle:nil];
}

@end
