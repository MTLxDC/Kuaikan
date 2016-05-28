//
//  ProgressHUD.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/25.
//  Copyright © 2016年 name. All rights reserved.
//

#import <JGProgressHUD.h>


typedef void (^dissmissCallBack)();

@interface ProgressHUD : NSObject


+ (dissmissCallBack)showProgressWithStatus:(NSString *)status inView:(UIView *)view;

+ (void)showErrorWithStatus:(NSString *)status inView:(UIView *)view;

+ (void)showSuccessWithStatus:(NSString *)status inView:(UIView *)view;

+ (void)showCustomImage:(NSString *)imageName inView:(UIView *)view;

@end
