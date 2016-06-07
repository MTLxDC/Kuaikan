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

@interface UserInfoManager () <UIAlertViewDelegate,MJCoding>

@property (nonatomic,copy) NSString *savePath;


@end

static NSString * const loginInfoFileName = @"loginInfo";   //账号密码保存文件名

static NSString * const userAuthorizeUrlString = @"http://api.kuaikanmanhua.com/v1/timeline/polling";

static NSString * const signinBaseUrlString = @"http://api.kuaikanmanhua.com/v1/phone/signin";

static NSString * const commentUrlFormat = @"http://api.kuaikanmanhua.com/v1/comics/%@/comments";
static NSString * const replyUrlFormat = @"http://api.kuaikanmanhua.com/v1/comments/%@/reply";

@implementation UserInfoManager

MJCodingImplementation

+ (instancetype)share
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoManager alloc] init];
    });
    
    return instance;
}


+ (void)autoLogin {
    [[UserInfoManager share] autoLogin];
}

- (void)autoLogin {
    
    NSString *loginInfoPath = [self.savePath stringByAppendingPathComponent:loginInfoFileName];
    
    NSDictionary *parameters = [NSKeyedUnarchiver unarchiveObjectWithFile:loginInfoPath];
    
    if (parameters.count < 1) return;
    
    [self loginWithPhone:parameters[phoneKey] WithPassword:parameters[passwordKey] loginSucceed:^(UserInfoManager *user) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:loginSuucceedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:loginStatusChangeNotification object:nil];
        
    } loginFailed:^(id faileResult, NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:loginFailedNotification object:nil userInfo:parameters];
        
    }];
}

- (void)saveUserInfoWithData:(NSDictionary *)data {
    
    self.hasLogin = YES;
    self.avatar_url = data[@"avatar_url"];
    self.ID = data[@"id"];
    self.nickname = data[@"nickname"];
    self.reg_type = data[@"reg_type"];
    self.update_remind_flag = data[@"update_remind_flag"];
    
}

- (void)logoutUserInfo {
    
    self.hasLogin = NO;
    self.avatar_url = nil;
    self.ID = nil;
    self.nickname = nil;
    self.reg_type = nil;
    self.update_remind_flag = nil;
    
    NSString *loginInfoPath = [self.savePath stringByAppendingPathComponent:loginInfoFileName];

    [[NSFileManager defaultManager] removeItemAtPath:loginInfoPath error:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:userLogoutNotification object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:loginStatusChangeNotification object:nil];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [LoginViewController show];
    }
}

+ (void)loginWithPhone:(NSString *)phone
          WithPassword:(NSString *)password
          loginSucceed:(void (^)(UserInfoManager *user))succeed
           loginFailed:(void (^)(id faileResult,NSError *error))failed {
    [[[self class] share] loginWithPhone:phone WithPassword:password loginSucceed:succeed loginFailed:failed];
}

- (void)loginWithPhone:(NSString *)phone
          WithPassword:(NSString *)password
           loginSucceed:(void (^)(UserInfoManager *user))succeed
           loginFailed:(void (^)(id faileResult,NSError *error))failed {
    
    NetWorkManager *manager = [NetWorkManager share];
    
    NSDictionary *parameters = @{passwordKey:password,
                                 phoneKey:phone};
    
    [manager requestWithMethod:@"POST" url:signinBaseUrlString parameters:parameters complish:^(id res, NSError *error) {
        
        if (error != nil) {
            if (failed) failed(res,error);
            return ;
        }
        
        NSDictionary *result = (NSDictionary *)res;
        
        NSString *message  = result[@"message"];
        NSDictionary *data = result[@"data"];
        
        if ([message isEqualToString:@"OK"] && data) {
            
            [self saveUserInfoWithData:data];
            
        NSString *loginInfoPath = [self.savePath stringByAppendingPathComponent:loginInfoFileName];
            
            [NSKeyedArchiver archiveRootObject:parameters toFile:loginInfoPath];
            
            [manager requestWithMethod:@"GET" url:userAuthorizeUrlString parameters:nil complish:^(id res, NSError *error) {
            }];
            
            if (succeed) succeed(self);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:loginSuucceedNotification object:nil];
            
        }else {
            
            if (failed) failed(res,error);
            
        }
        
    }];

}


+ (void)sendMessage:(NSString *)meassage isReply:(BOOL)isreply withID:(NSString *)ID withSucceededCallback:(void (^)(CommentsModel *))succeededCallback {
    [[UserInfoManager share] sendMessage:meassage isReply:isreply withID:ID withSucceededCallback:succeededCallback];
}

- (void)sendMessage:(NSString *)meassage
            isReply:(BOOL)isreply
        withID:(NSString *)ID
withSucceededCallback:(void (^)(CommentsModel *model))succeededCallback {
    
    
    if (self.hasLogin == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未登录" message:@"是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
        return;
    }
    
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
    
    NSString *urlFormat = isreply ? replyUrlFormat : commentUrlFormat;
    
    NSString *url = [NSString stringWithFormat:urlFormat,ID];
    
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
        
        if (comment.count > 0) {
            
            [ProgressHUD showSuccessWithStatus:@"发送成功" inView:topWindow];
            
            if (succeededCallback) {
                
                CommentsModel *model = [CommentsModel mj_objectWithKeyValues:comment];
                
                succeededCallback(model);
                
            }
            
        }else {
            [ProgressHUD showErrorWithStatus:@"发送失败" inView:topWindow];
        }
        
    }];
}


- (NSString *)savePath {
    if (!_savePath) {
        
         _savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:NSStringFromClass([self class])];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:_savePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return _savePath;
    
}

@end
