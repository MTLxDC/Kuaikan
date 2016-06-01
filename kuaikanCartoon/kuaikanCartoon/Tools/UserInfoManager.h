//
//  UserInfoManager.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/24.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentsModel;

@interface UserInfoManager : NSObject


+ (instancetype)share;

@property BOOL hasLogin;

@property (nonatomic,copy)   NSString *icon_url;      //头像

@property (nonatomic,strong) NSNumber *ID;              //ID

@property (nonatomic,copy)   NSString *nickname;        //昵称

@property (nonatomic,copy)   NSString *reg_type;

@property (nonatomic,strong) NSNumber *update_remind_flag;


- (void)saveUserInfoWithData:(NSDictionary *)data;

- (void)logoutUserInfo; //注销

- (void)sendComment:(NSString *)meassage
        withWordsID:(NSString *)wordsID
withSucceededCallback:(void (^)(CommentsModel *model))succeededCallback;

@end
