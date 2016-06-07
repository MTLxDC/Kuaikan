//
//  LoginViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/23.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseViewController.h"

@class UserInfoManager;

typedef void (^loginSucceededCallback)(UserInfoManager *userInfo);

@interface LoginViewController : BaseViewController

@property (nonatomic,copy) loginSucceededCallback loginSucceeded;

+ (void)show;
+ (void)showWithloginSucceeded:(loginSucceededCallback)loginSucceeded;

@end
