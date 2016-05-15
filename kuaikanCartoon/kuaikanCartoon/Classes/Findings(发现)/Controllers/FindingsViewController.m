//
//  FindingsViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "navBarTitleView.h"
#import "FindingsViewController.h"
#import "topicInfoModel.h"
#import "bannerModel.h"
#import "CommonMacro.h"
#import "DCPicScrollView.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>
#import "CartoonDetailViewController.h"

@interface FindingsViewController ()<UITableViewDataSource,UITableViewDelegate,DCPicScrollViewDataSource,DCPicScrollViewDelegate>

@property (nonatomic,weak) UITableView *mainView;

@property (nonatomic,weak) DCPicScrollView *bannerView;

@property (nonatomic,copy) NSArray *modelArray;

@property (nonatomic,copy) NSArray *bannerModelArray;

@end

@implementation FindingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    
    [self setupMainView];
    
    [self requestData];
    
}


- (void)requestData {
    
    NSString *bannerDataUrl = @"http://api.kuaikanmanhua.com/v1/banners?";
    
    NSString *topicInfoDataUrl = @"http://api.kuaikanmanhua.com/v1/topic_lists/mixed/new?";
    
    weakself(self);
    
    [bannerModel requestModelDataWithUrlString:bannerDataUrl complish:^(id result) {
        weakSelf.bannerModelArray = result;
        [weakSelf.bannerView reloadData];
    } cachingPolicy:ModelDataCachingPolicyDefault];
    
    [topicInfoModel requestModelDataWithUrlString:topicInfoDataUrl complish:^(id result) {
        weakSelf.modelArray = result;
        
    } cachingPolicy:ModelDataCachingPolicyDefault];
    
}

- (void)setNavBar {
    
    navBarTitleView *titleView = [navBarTitleView defaultTitleView];
    
    [titleView.leftBtn setTitle:@"热门" forState:UIControlStateNormal];
    
    [titleView.rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    
    self.navigationItem.titleView = titleView;
    
    [titleView setLeftBtnOnClick:^(UIButton *btn) {
        
    }];
    
    [titleView setRightBtnOnClick:^(UIButton *btn) {
        
    }];
    
    
    UIImage *searchIcon = [[UIImage imageNamed:@"ic_searchbar_15x16_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searchIcon style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = search;

}

- (void)search {
    
}

- (void)setupMainView {
    
    UITableView *mainView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:mainView];

    self.mainView = mainView;
    
    [self setupPicScrollView];
}

#pragma mark 设置无线轮播器

- (void)setupPicScrollView {
    
    DCPicScrollViewConfiguration *pcv = [DCPicScrollViewConfiguration defaultConfiguration];
    
    pcv.pageAlignment = PageContolAlignmentCenter;
    
    DCPicScrollView *ps = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 200) withConfiguration:pcv withDataSource:self];
    
    ps.delegate = self;
    
    self.mainView.tableHeaderView = ps;
    
    self.bannerView = ps;
}

#pragma mark 无线轮播器代理方法

- (void)picScrollView:(DCPicScrollView *)picScrollView needUpdateItem:(DCPicItem *)item atIndex:(NSInteger)index {
    bannerModel *md = [self.bannerModelArray objectAtIndex:index];
    
    [item.imageView sd_setImageWithURL:[NSURL URLWithString:md.pic] placeholderImage:[UIImage imageNamed:@"ic_common_placeholder_l_120x38_"]];

}

- (void)picScrollView:(DCPicScrollView *)picScrollView selectItem:(DCPicItem *)item atIndex:(NSInteger)index {
    bannerModel *md = [self.bannerModelArray objectAtIndex:index];
    
    CartoonDetailViewController *cdv = [[CartoonDetailViewController alloc] init];
    cdv.cartoonId = md.value;
    [self.navigationController pushViewController:cdv animated:YES];
}

- (NSUInteger)numberOfItemsInPicScrollView:(DCPicScrollView *)picScrollView {
    return self.bannerModelArray.count;
}

@end
