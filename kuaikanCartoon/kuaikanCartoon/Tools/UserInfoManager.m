//
//  UserInfoManager.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/24.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UserInfoManager.h"

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



@end
