//
//  UserNotLoginTipView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/29.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,tipOption) {
    tipOptionNotLogin,          //用户没有登录
    tipOptionNotConcerned,      //登录但没有作品
};

@interface UserNotLoginTipView : UIView

@property (nonatomic,copy) void (^loginOnClick)(UserNotLoginTipView *sender);

@property (nonatomic) tipOption tip;

+ (instancetype)makeUserNotLoginTipView;

@end
