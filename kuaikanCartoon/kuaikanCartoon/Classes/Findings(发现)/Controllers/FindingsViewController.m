//
//  FindingsViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//


#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#import "topicInfoModel.h"
#import "bannerModel.h"
#import "CommonMacro.h"

#import "navBarTitleView.h"
#import "DCPicScrollView.h"
#import "FindHeaderSectionView.h"

#import "RenQiBiaoShengCell.h"
#import "MeiZhouPaiHangCell.h"
#import "XinZuoCell.h"
#import "ZhuBianLiTuiCell.h"
#import "GuanFangHuoDongCell.h"

#import "FindingsViewController.h"
#import "CartoonDetailViewController.h"
#import "SearchViewController.h"

#import "UIBarButtonItem+EXtension.h"
#import "UIView+Extension.h"


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
    
    [self requestDataWithCachingPolicy:ModelDataCachingPolicyDefault];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.bannerView.timer begin];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.bannerView.timer pause];
}


- (void)requestDataWithCachingPolicy:(ModelDataCachingPolicy)cachingPolicy {
    
    NSString *bannerDataUrl = @"http://api.kuaikanmanhua.com/v1/banners";
    
    NSString *topicInfoDataUrl = @"http://api.kuaikanmanhua.com/v1/topic_lists/mixed/new";
    
    weakself(self);
    
    [bannerModel requestModelDataWithUrlString:bannerDataUrl complish:^(id result) {
        weakSelf.bannerModelArray = result;
        [weakSelf.bannerView reloadData];
    } cachingPolicy:cachingPolicy hubInView:self.view];
    
    [topicInfoModel requestModelDataWithUrlString:topicInfoDataUrl complish:^(id result) {
        weakSelf.modelArray = result;
        [weakSelf.mainView reloadData];
        [weakSelf.mainView.mj_header endRefreshing];
    } cachingPolicy:cachingPolicy hubInView:self.view];
    
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
    
    
    UIBarButtonItem *search = [UIBarButtonItem barButtonItemWithImage:@"ic_discover_nav_search_normal_19x19_"
                    pressImage:@"ic_discover_nav_search_pressed_19x19_"
                    target:self action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = search;

}

- (void)search {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[SearchViewController new]];
    
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma mark 设置tableview为主要视图

static NSString * const RenQiBiaoShengCellIdentifier    = @"RenQiBiaoShengCell";
static NSString * const MeiZhouPaiHangCellIdentifier    = @"MeiZhouPaiHangCell";
static NSString * const XinZuoCellIdentifier            = @"XinZuoCell";
static NSString * const ZhuBianLiTuiCellIdentifier      = @"ZhuBianLiTuiCell";
static NSString * const GuanFangHuoDongCellIdentifier   = @"GuanFangHuoDongCell";

- (void)setupMainView {
    
    weakself(self);
    
    UITableView *mainView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    mainView.dataSource = self;
    mainView.delegate   = self;
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.separatorStyle  = UITableViewCellSeparatorStyleNone;

    [mainView registerClass:[RenQiBiaoShengCell class]  forCellReuseIdentifier:RenQiBiaoShengCellIdentifier];       //人气飙升
    [mainView registerClass:[MeiZhouPaiHangCell class]  forCellReuseIdentifier:MeiZhouPaiHangCellIdentifier];       //每周排行榜
    [mainView registerClass:[XinZuoCell class]          forCellReuseIdentifier:XinZuoCellIdentifier];               //新作出炉
    [mainView registerClass:[ZhuBianLiTuiCell class]    forCellReuseIdentifier:ZhuBianLiTuiCellIdentifier];         //主播力推
    [mainView registerClass:[GuanFangHuoDongCell class] forCellReuseIdentifier:GuanFangHuoDongCellIdentifier];      //官方活动
    
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataWithCachingPolicy:ModelDataCachingPolicyReload];
    }];
    
    [normalHeader.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
    
    mainView.mj_header = normalHeader;
    
    [self.view addSubview:mainView];

    self.mainView = mainView;
    
    [self setupPicScrollView];
}

#pragma mark tableView的代理方法


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *Identifier = nil;
    
    switch (indexPath.section) {
        case 0:Identifier = RenQiBiaoShengCellIdentifier;break;      //人气飙升
        case 1:Identifier = MeiZhouPaiHangCellIdentifier;break;      //每周排行榜
        case 2:Identifier = XinZuoCellIdentifier;break;              //新作出炉
        case 3:Identifier = ZhuBianLiTuiCellIdentifier;break;        //主播力推
        case 4:Identifier = GuanFangHuoDongCellIdentifier;break;     //官方活动
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    topicInfoModel *md = [self.modelArray objectAtIndex:indexPath.section];
    
    if (indexPath.section == 4) {
        [cell performSelector:@selector(setTopics:) withObject:md.banners];
    }else {
        [cell performSelector:@selector(setTopics:) withObject:md.topics];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    topicInfoModel *md = [self.modelArray objectAtIndex:section];
    
    FindHeaderSectionView *head = [[FindHeaderSectionView alloc] init];
    
    head.title = md.title;
    
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:return 150;      //人气飙升
        case 1:return 300;      //每周排行榜
        case 2:return 270;      //新作出炉
        case 3:return 270;      //主播力推
        case 4:return 100;      //官方活动
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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
