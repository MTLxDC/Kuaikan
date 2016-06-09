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
#import "LoginViewController.h"

@interface HomeViewController ()

@property (nonatomic,weak) UIScrollView *mainView;

@property (nonatomic,weak) WordsListView *wlv;

@property (nonatomic,weak) UserNotLoginTipView *tipView;

@property (nonatomic,weak) UIScrollView *tipViewContainer;


@end

static NSString * const usersCorcernedWordsUrl = @"http://api.kuaikanmanhua.com/v1/fav/timeline";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self setupTitleView];
   
    [self setupSearchItem];
    
    [self setupMainView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange) name:loginStatusChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    wlv.hidden = YES;
    wlv.hasTimeline = YES;
   
    
    updateCartoonView *cv = [[updateCartoonView alloc] initWithFrame:CGRectMake(mainView.width, 0, mainView.width, mainView.height)];
    
    UserNotLoginTipView *tipView = [UserNotLoginTipView makeUserNotLoginTipView];
    
    tipView.frame  = wlv.frame;
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:tipView.frame];
    
    [sc setContentSize:CGSizeMake(0,self.view.bounds.size.height)];
    
    sc.showsVerticalScrollIndicator = NO;
    
    [sc addSubview:tipView];
    
    weakself(self);
    
    [wlv setNoDataCallBack:^{
        weakSelf.tipView.tip = tipOptionNotConcerned;
        weakSelf.tipViewContainer.hidden = NO;
    }];
    
    [tipView setLoginOnClick:^(UserNotLoginTipView *tv) {
       
        if (tv.tip == tipOptionNotLogin) {
            
            [LoginViewController show];
            
        }else if (tv.tip == tipOptionNotConcerned) {
            
            weakSelf.tabBarController.selectedIndex = 1;
            
        }
        
    }];
    
    [mainView addSubview:wlv];
    [mainView addSubview:sc];
    [mainView addSubview:cv];
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
    self.wlv = wlv;
    self.tipView = tipView;
    self.tipViewContainer = sc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:subjectColor];
    
    [self loginStatusChange];
}

- (void)loginStatusChange {
    
    BOOL haslogin = [[UserInfoManager share] hasLogin];
    
    self.tipViewContainer.hidden = haslogin;
    
    self.wlv.hidden = !haslogin;

    if (haslogin) {
        self.wlv.urlString = usersCorcernedWordsUrl;
    }

}



@end
