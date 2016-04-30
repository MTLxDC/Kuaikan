//
//  MainTabBarController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MainTabBarController.h"

#import "HomeViewController.h"
#import "FindingsViewController.h"
#import "PersonalViewController.h"
#import "BaseNavigationController.h"
#import "MainTabbar.h"
#import "CommonMacro.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)loadView {
    [super loadView];
    
    CGFloat h = 44;
    CGFloat y = SCREEN_HEIGHT - h;
    
    
    weakself(self);
 
    MainTabbar *tabbar = [[MainTabbar alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
    tabbar.backgroundColor = [UIColor whiteColor];
    [tabbar addItemWithImageNames:@[@"home",@"discover",@"me"]];
    [tabbar setSelectAtIndex:^(UIButton *btn, NSInteger index) {
        weakSelf.selectedIndex = index;
    }];
    [self.view addSubview:tabbar];

    [self.tabBar removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    HomeViewController * home = [[HomeViewController alloc] init];
    
    FindingsViewController * find = [[FindingsViewController alloc] init];

    PersonalViewController * person = [[PersonalViewController alloc] init];

    
    [self addChildViewControllers:@[home,find,person]];
}

- (void)addChildViewControllers:(NSArray *)childControllers  {
    
    for (NSInteger index = 0; index < childControllers.count; index++) {
        BaseNavigationController *navHome = [[BaseNavigationController alloc] initWithRootViewController:childControllers[index]];
        [super addChildViewController:navHome];
    }
}




@end
