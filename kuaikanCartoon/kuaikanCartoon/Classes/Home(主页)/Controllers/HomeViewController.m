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
#import "updateCartoonView.h"
#import "Color.h"

#import "UIView+Extension.h"

@interface HomeViewController ()

@property (nonatomic,weak) UIButton *leftBtn;
@property (nonatomic,weak) UIButton *rightBtn;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleView];
   
    [self setupSearchItem];
    
    [self setupMainView];
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
    
    self.navigationItem.titleView = titleView;
    
    titleView.leftBtnOnClick = ^(UIButton *btn){
        NSLog(@"%@",btn);
    };
    
    titleView.rightBtnOnClick = ^(UIButton *btn){
        NSLog(@"%@",btn);
    };
    
}

- (void)setupMainView {
    
    updateCartoonView *v = [[updateCartoonView alloc] initWithFrame:CGRectMake(0,navHeight, self.view.width,self.view.height - 44)];
    [self.view addSubview:v];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:subjectColor];

}




@end
