//
//  SettingTableViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/26.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UserInfoManager.h"
#import "MainTabBarController.h"

@interface SettingTableViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *LogoutBtn;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MainTabBarController *main = (MainTabBarController *)self.tabBarController;
    
    [main setHidesBottomBar:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.LogoutBtn.hidden = ![UserInfoManager share].hasLogin;
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Logout:(id)sender {
    
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注销" message:@"确定要注销登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[UserInfoManager share] logoutUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
