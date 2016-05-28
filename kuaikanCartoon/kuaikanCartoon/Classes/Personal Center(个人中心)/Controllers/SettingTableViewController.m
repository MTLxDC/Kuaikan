//
//  SettingTableViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/26.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UserInfoManager.h"

@interface SettingTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LogoutBtn;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.LogoutBtn.hidden = ![UserInfoManager share].hasLogin;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Logout:(id)sender {
    [[UserInfoManager share] logoutUserInfo];
}

@end
