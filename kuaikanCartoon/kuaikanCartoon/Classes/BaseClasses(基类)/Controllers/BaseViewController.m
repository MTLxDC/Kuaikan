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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
}

- (void)setBackItemWithImage:(NSString *)image pressImage:(NSString *)pressImage {
    
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithImage:image pressImage:pressImage target:self action:@selector(back)];
    
    [self.navigationItem setLeftBarButtonItem:back];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count == 1) {
        MainTabBarController *main = (MainTabBarController *)self.tabBarController;
        
        [UIView animateWithDuration:0.25 delay:1 usingSpringWithDamping:0.8f initialSpringVelocity:15.0f options:UIViewAnimationOptionTransitionNone animations:^{
            
            [main.mainTabbar setY:SCREEN_HEIGHT - 44];

        } completion:^(BOOL finished) {
            
        }];

    }
    
   
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count < 2) return;
    MainTabBarController *main = (MainTabBarController *)self.tabBarController;
    [UIView animateWithDuration:0.25 animations:^{
        [main.mainTabbar setY:SCREEN_HEIGHT];
    }];
}

@end
