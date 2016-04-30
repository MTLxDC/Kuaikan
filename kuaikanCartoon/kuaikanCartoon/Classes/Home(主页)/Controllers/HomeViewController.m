//
//  HomeViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "HomeViewController.h"
#import "CommonMacro.h"
#import "navBarTitleView.h"
#import <UIControl+BlocksKit.h>

@interface HomeViewController ()

@property (nonatomic,weak) UIButton *leftBtn;
@property (nonatomic,weak) UIButton *rightBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setBarTintColor:subjectColor];
    
    [self setupTitleView];
   
    [self setupSearchItem];
}

- (void)setupSearchItem {
    
    UIImage *searchIcon = [[UIImage imageNamed:@"ic_searchbar_15x16_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searchIcon style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = search;
    
    
}

- (void)search {
    printf("%s\n",__func__);
}


- (void)setupTitleView {
    
    navBarTitleView *titleView = [navBarTitleView defaultTitleView];
    
    self.leftBtn = titleView.leftButton;
    self.rightBtn = titleView.rightButton;
    
    [self.leftBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"更新" forState:UIControlStateNormal];
    
    [self.navigationItem setTitleView:titleView];
    
    weakself(self);
    
    [self.leftBtn bk_addEventHandler:^(id sender) {
        
        [weakSelf selectBtn:self.leftBtn];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightBtn bk_addEventHandler:^(id sender) {
        
        [weakSelf selectBtn:self.rightBtn];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self selectBtn:self.rightBtn];
    
}

- (void)selectBtn:(UIButton *)btn {
   
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:subjectColor forState:UIControlStateNormal];
    
    if (btn == self.leftBtn) {
        [self.rightBtn setBackgroundColor:[UIColor clearColor]];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [self.leftBtn setBackgroundColor:[UIColor clearColor]];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}



@end
