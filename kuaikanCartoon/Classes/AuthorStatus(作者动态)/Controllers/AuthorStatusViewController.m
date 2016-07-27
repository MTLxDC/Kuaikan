//
//  AuthorStatusViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorStatusViewController.h"

#import "ListView.h"
#import "CommonMacro.h"
#import "UIView+Extension.h"
#import <MJRefresh.h>

#import "FeedsTableView.h"
#import "StatusCell.h"
#import "FeedsDataModel.h"

@interface AuthorStatusViewController () <UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *mainView;

@property (nonatomic,weak) ListView *titleView;

@property (nonatomic,weak) FeedsTableView *hotFeedsTableView;

@property (nonatomic,weak) FeedsTableView *newsFeedsTableView;

@property (nonatomic,weak) FeedsTableView *followFeedsTableView;

@property (nonatomic,strong) FeedsDataModel *modelData;

@property (nonatomic,weak) UIView *customNavBar;

@property (nonatomic,weak) ListView *listView;

@end

@implementation AuthorStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMainView];
    
    [self setupCustomNavBar];
    
    [self setupFeedsTableView];
    
    [self.followFeedsTableView  updateWithDataType:usersConcernedData];
    [self.hotFeedsTableView     updateWithDataType:hotData];
    [self.newsFeedsTableView    updateWithDataType:newsData];
}

- (void)setupCustomNavBar {
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    UIView *customNavBar = [[UIView alloc] init];
    customNavBar.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    NSArray *textArray = @[@"关注",@"热门",@"最新"];
    
    CGFloat listViewWidth    = self.view.width * 0.66;
    CGFloat listViewItemSize = (listViewWidth - SPACEING * 2)/textArray.count;
    
    ListViewConfiguration *lc = [ListViewConfiguration new];
    
    lc.hasSelectAnimate = YES;
    lc.labelSelectTextColor = subjectColor;
    lc.labelTextColor = [UIColor blackColor];
    lc.lineColor  = subjectColor;
    lc.font       = [UIFont systemFontOfSize:14];
    lc.spaceing   = SPACEING;
    lc.labelWidth = listViewItemSize;
    lc.monitorScrollView = self.mainView;
    
    CGFloat x = (self.view.width - listViewWidth) * 0.5;
    
    ListView *listView = [[ListView alloc] initWithFrame:CGRectMake(x,20,listViewWidth,44) TextArray:textArray Configuration:lc];
    
    [customNavBar addSubview:listView];
    [self.view addSubview:customNavBar];
    
     self.customNavBar = customNavBar;
     self.listView = listView;
    
}

- (void)setupMainView {
    
    UIScrollView *mainView = [[UIScrollView alloc] init];
    
    mainView.bounces = NO;
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.delegate = self;
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
    
}

- (void)setupFeedsTableView {
    
    self.followFeedsTableView   = [self creatFeedsTableView];
    self.hotFeedsTableView      = [self creatFeedsTableView];
    self.newsFeedsTableView     = [self creatFeedsTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat height = self.view.height - bottomBarHeight - navHeight;
    CGFloat width  = self.view.width;
    
    CGFloat listViewWidth = width * 0.66;
    CGFloat x = (width - listViewWidth) * 0.5;
    
    [self.mainView setFrame:CGRectMake(0,navHeight,width,height)];
     self.mainView.contentSize  = CGSizeMake(width * 3, 0);
    
    [self.listView setFrame:CGRectMake(x,20,listViewWidth,44)];
    
    [self.followFeedsTableView  setFrame:CGRectMake(0, 0, width,height)];
    [self.hotFeedsTableView     setFrame:CGRectMake(width,0,width,height)];
    [self.newsFeedsTableView    setFrame:CGRectMake(width * 2, 0, width, height)];
    
    [self.mainView setContentOffset:CGPointMake(width, 0)];
}

- (FeedsTableView *)creatFeedsTableView {

    FeedsTableView *ftv = [[FeedsTableView alloc] init];
    [self.mainView addSubview:ftv];
    
    return ftv;
}



@end
