//
//  UserInfoManager.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/24.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UserInfoManager.h"
#import "NetWorkManager.h"
#import "ProgressHUD.h"
#import "CommentsModel.h"
#import "LoginViewController.h"

@interface UserInfoManager () <UIAlertViewDelegate>



@end

@implementation UserInfoManager

+ (instancetype)share
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoManager alloc] init];
    });
    
    return instance;
}

- (void)saveUserInfoWithData:(NSDictionary *)data {
    self.hasLogin = YES;
    self.icon_url = data[@"avatar_url"];
    self.ID = data[@"id"];
    self.nickname = data[@"nickname"];
    self.reg_type = data[@"reg_type"];
    self.update_remind_flag = data[@"update_remind_flag"];
    
   
}

- (void)logoutUserInfo {
    
    self.hasLogin = NO;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [LoginViewController show];
    }
}

- (void)sendComment:(NSString *)meassage
        withWordsID:(NSString *)wordsID
        withSucceededCallback:(void (^)(CommentsModel *model))succeededCallback {
    
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];


    if (self.hasLogin == NO) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未登录" message:@"是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comics/%@/comments",wordsID];
    
    
  dissmissCallBack dissmiss = [ProgressHUD showProgressWithStatus:@"发送中..." inView:topWindow];
    
    NetWorkManager *manager = [NetWorkManager share];
    
    NSDictionary *parameters = @{@"content" : meassage};
    
    [manager requestWithMethod:@"POST" url:url parameters:parameters complish:^(id res, NSError *error) {
        
        dissmiss();
        
        if (res == nil || error != nil) {
            [ProgressHUD showErrorWithStatus:@"发送失败" inView:topWindow];
            return ;
        }
        
        NSDictionary *data = (NSDictionary *)res;
        
        NSDictionary *comment = data[@"data"][@"comment"];
        
        if (comment) {
            
         [ProgressHUD showSuccessWithStatus:@"发送成功" inView:topWindow];
        
         CommentsModel *model = [CommentsModel mj_objectWithKeyValues:comment];
            
         succeededCallback(model);

        }else {
            [ProgressHUD showErrorWithStatus:@"发送失败" inView:topWindow];
        }
        
    }];
    
}






@end
