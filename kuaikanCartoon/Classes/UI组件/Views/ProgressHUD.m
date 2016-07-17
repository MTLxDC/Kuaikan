//
//  ProgressHUD.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/25.
//  Copyright © 2016年 name. All rights reserved.
//

#import "ProgressHUD.h"

static CGFloat dissmissDelay = 1;
static JGProgressHUDStyle style = JGProgressHUDStyleExtraLight;


@implementation ProgressHUD

+ (dissmissCallBack)showProgressWithStatus:(NSString *)status inView:(UIView *)view {
    
    if (!view) return ^{};
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:style];
    
    HUD.userInteractionEnabled = NO;
    [HUD showInView:view];
    
    return ^{[HUD dismiss];};
}




+ (void)showErrorWithStatus:(NSString *)status inView:(UIView *)view {
    if (!view) return;
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:style];
    
    HUD.textLabel.textColor = [[UIColor alloc] initWithWhite:0.4 alpha:1];
    
     HUD.textLabel.text = status;
     HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init]; //
     HUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
     HUD.userInteractionEnabled = NO;

    [HUD showInView:view];
    [HUD dismissAfterDelay:dissmissDelay];
    
}

+ (void)showSuccessWithStatus:(NSString *)status inView:(UIView *)view {
    
    if (!view) return;
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:style];
    
    HUD.textLabel.text = status;
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init]; //
    HUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
    HUD.userInteractionEnabled = NO;

    [HUD showInView:view];
    [HUD dismissAfterDelay:dissmissDelay];
    
}

+ (void)showCustomImage:(NSString *)imageName inView:(UIView *)view {
    
    if (!view) return;
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:style];
    
    HUD.userInteractionEnabled = NO;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
    HUD.indicatorView = [[JGProgressHUDImageIndicatorView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    [HUD showInView:view];

    [HUD dismissAfterDelay:dissmissDelay];
    
}



@end
