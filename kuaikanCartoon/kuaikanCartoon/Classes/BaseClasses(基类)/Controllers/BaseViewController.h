//
//  BaseViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic) BOOL statusBarHidden;

@property (nonatomic) UIStatusBarStyle statusBarStyle;

- (void)setBackItemWithImage:(NSString *)image pressImage:(NSString *)pressImage;

- (void)hideNavBar:(BOOL)ishide;

@end
