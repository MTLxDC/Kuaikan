//
//  LoginViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/23.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoManager;

@interface LoginViewController : UIViewController

@property (nonatomic,copy) void (^loginSucceeded)(UserInfoManager *userInfo);

@end
