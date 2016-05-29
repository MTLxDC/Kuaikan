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
#import "SearchViewController.h"
#import "WordsListView.h"
#import "UIView+Extension.h"
#import "UserNotLoginTipView.h"
#import "UserInfoManager.h"

@interface HomeViewController ()

@property (nonatomic,weak) UIButton *leftBtn;
@property (nonatomic,weak) UIButton *rightBtn;

@property (nonatomic,weak) UIScrollView *mainView;

@property (nonatomic,weak) WordsListView *wlv;

@property (nonatomic,weak) UserNotLoginTipView *tipView;

@end

static NSString * const usersCorcernedWordsUrl = @"http://api.kuaikanmanhua.com/v1/fav/timeline";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
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
   
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:NO completion:^{
        
    }];
    
}


- (void)setupTitleView {
    
    navBarTitleView *titleView = [navBarTitleView defaultTitleView];
    
    self.navigationItem.titleView = titleView;
    
    weakself(self);
    
    titleView.leftBtnOnClick = ^(UIButton *btn){
         weakSelf.wlv.urlString = usersCorcernedWordsUrl;
        
       UserInfoManager *user = [UserInfoManager share];
        
        
        if (!user.hasLogin) {
            self.tipView.tip = tipOptionNotLogin;
        }
        
        [weakSelf.mainView setContentOffset:CGPointZero animated:YES];
    };
    
    titleView.rightBtnOnClick = ^(UIButton *btn){
        [weakSelf.mainView setContentOffset:CGPointMake(self.mainView.width, 0) animated:YES];
    };
    
}

- (void)setupMainView {
        
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,navHeight, self.view.width,self.view.height - 44)];
    
    mainView.scrollEnabled = NO;
    mainView.contentSize   = CGSizeMake(mainView.width * 2, 0);
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    
    [mainView setContentOffset:CGPointMake(mainView.width, 0)];

    
    WordsListView *wlv = [[WordsListView alloc] initWithFrame:CGRectMake(0, 0, mainView.width, mainView.height) style:UITableViewStyleGrouped];
    
    wlv.hasTimeline = YES;
    
    updateCartoonView *cv = [[updateCartoonView alloc] initWithFrame:CGRectMake(mainView.width, 0, mainView.width, mainView.height)];
    
    UserNotLoginTipView *tipView = [UserNotLoginTipView makeUserNotLoginTipView];
    
    
    tipView.frame  = wlv.frame;
    tipView.hidden = YES;
    
    [mainView addSubview:wlv];
    [mainView addSubview:tipView];
    [mainView addSubview:cv];
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
    self.wlv = wlv;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:subjectColor];

}




@end
