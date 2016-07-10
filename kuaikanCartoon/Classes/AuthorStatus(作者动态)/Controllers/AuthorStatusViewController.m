//
//  AuthorStatusViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorStatusViewController.h"
#import "navBarTitleView.h"
#import "CommonMacro.h"
#import "UIView+Extension.h"
#import <MJRefresh.h>

#import "FeedsTableView.h"
#import "StatusCell.h"
#import "FeedsDataModel.h"

@interface AuthorStatusViewController () <UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *mainView;

@property (nonatomic,weak) navBarTitleView *titleView;

@property (nonatomic,weak) FeedsTableView *hotFeedsTableView;

@property (nonatomic,weak) FeedsTableView *newsFeedsTableView;

@property (nonatomic,strong) FeedsDataModel *modelData;

@end

@implementation AuthorStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMainView];
    
    [self setupTitleView];
    
    [self setupFeedsTableView];
    
    [self.hotFeedsTableView  updateWithDataType:hotData];
    [self.newsFeedsTableView updateWithDataType:newsData];

}

static bool flag = NO;

- (void)setupTitleView {
    
    navBarTitleView *titleView = [navBarTitleView defaultTitleView];
    
    [titleView.leftBtn  setTitle:@"热门" forState:UIControlStateNormal];
    [titleView.rightBtn setTitle:@"最新" forState:UIControlStateNormal];

    weakself(self);
    
    titleView.leftBtnOnClick = ^(UIButton *btn){
        if (flag) return;
        [weakSelf.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
    };
    
    titleView.rightBtnOnClick = ^(UIButton *btn){
        if (flag) return;
        [weakSelf.mainView setContentOffset:CGPointMake(weakSelf.mainView.width, 0) animated:YES];
    };
    
    [titleView selectBtn:titleView.leftBtn];
    
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
}

- (void)setupMainView {
    
    CGFloat mainViewHeight = self.view.height - bottomBarHeight;
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,navHeight, self.view.width,mainViewHeight)];
    
    mainView.bounces = NO;
    mainView.contentSize   = CGSizeMake(mainView.width * 2, 0);
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.delegate = self;
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    BOOL isRight = velocity.x > 0;
    
    flag = YES;
    
    if (isRight) {
        [self.titleView selectBtn:self.titleView.rightBtn];
    }else {
        [self.titleView selectBtn:self.titleView.leftBtn];
    }
    
    flag = NO;
}

- (void)setupFeedsTableView {
    
    self.hotFeedsTableView  = [self creatFeedsTableView];
    self.newsFeedsTableView = [self creatFeedsTableView];
    
    [self.hotFeedsTableView  setFrame:self.mainView.bounds];
    [self.newsFeedsTableView setFrame:CGRectMake(self.mainView.width,0,self.mainView.width,self.mainView.height)];
    
}

- (FeedsTableView *)creatFeedsTableView {

    FeedsTableView *ftv = [[FeedsTableView alloc] init];
    
    [self.mainView addSubview:ftv];
    
    return ftv;
}


@end
