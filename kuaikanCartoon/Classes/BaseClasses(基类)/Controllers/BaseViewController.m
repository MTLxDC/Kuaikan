//
//  BaseViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBarButtonItem+EXtension.h"
#import "MainTabBarController.h"
#import "UIView+Extension.h"
#import "CommonMacro.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _statusBarHidden = NO;
        _statusBarStyle  = UIStatusBarStyleDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

}

- (void)setBackItemWithImage:(NSString *)image pressImage:(NSString *)pressImage {
    
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithImage:image pressImage:pressImage target:self action:@selector(back)];
    
    [self.navigationItem setLeftBarButtonItem:back];
    
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if (_statusBarHidden != statusBarHidden) {
        _statusBarHidden = statusBarHidden;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if (_statusBarStyle != statusBarStyle) {
        _statusBarStyle = statusBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (void)hideNavBar:(BOOL)ishide {
    
    _statusBarHidden = ishide;
    
    [self.navigationController setNavigationBarHidden:ishide animated:YES];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1]];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    [super viewWillAppear:animated];

    MainTabBarController *main = (MainTabBarController *)self.tabBarController;
    [main setHidesBottomBar:self.navigationController.viewControllers.count > 1];
    
}

@end
