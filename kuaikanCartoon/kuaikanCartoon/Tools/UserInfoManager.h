//
//  UserInfoManager.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/24.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const passwordKey = @"password";
static NSString * const phoneKey    = @"phone";


//用户注销
static NSString * const userLogoutNotification        = @"UserLogoutNotification";

//登陆成功
static NSString * const loginSuucceedNotification     = @"UserLoginSuucceedNotification";

//登录失败 userInfo is a dict object,please use phoneKey and passwordKey get value

static NSString * const loginFailedNotification       = @"UserLoginFailedNotification";

//登录状态发生改变
static NSString * const loginStatusChangeNotification = @"UserLoginStatusChangeNotification";


@class CommentsModel;

@interface UserInfoManager : NSObject

+ (instancetype)share;

@property BOOL hasLogin;

@property (nonatomic,copy)   NSString *avatar_url;      //头像

@property (nonatomic,strong) NSNumber *ID;              //ID

@property (nonatomic,copy)   NSString *nickname;        //昵称

@property (nonatomic,copy)   NSString *reg_type;

@property (nonatomic,strong) NSNumber *update_remind_flag;


+ (void)autoLogin;  //自动登录,前提是登录过并且网络正常

+ (void)sendMessage:(NSString *)meassage        //评论和回复
            isReply:(BOOL)isreply               //是否是回复
             withID:(NSString *)ID              //评论使用作品的ID,回复使用要回复的用户评论ID
             withSucceededCallback:(void (^)(CommentsModel *))succeededCallback;

+ (void)loginWithPhone:(NSString *)phone        //登录
          WithPassword:(NSString *)password
          loginSucceed:(void (^)(UserInfoManager *user))succeed
           loginFailed:(void (^)(id faileResult,NSError *error))failed;

- (void)saveUserInfoWithData:(NSDictionary *)data;

- (void)logoutUserInfo; //注销

@end
