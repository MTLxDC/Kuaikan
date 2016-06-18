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
#import "WordsDetailViewController.h"

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
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    
    [self setNavBar];
    
    [self setupMainView];
    
    [self requestDataWithCachingPolicy:ModelDataCachingPolicyDefault];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
        if (!result) return ;
        weakSelf.bannerModelArray = result;
        [weakSelf.bannerView reloadData];
    } cachingPolicy:cachingPolicy hubInView:self.view];
    
    [topicInfoModel requestModelDataWithUrlString:topicInfoDataUrl complish:^(id result) {
        [weakSelf.mainView.mj_header endRefreshing];
        if (!result) return ;
        weakSelf.modelArray = result;
        [weakSelf.mainView reloadData];
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
     
    if ([cell isKindOfClass:[MeiZhouPaiHangCell class]]) {
        MeiZhouPaiHangCell *mzph = (MeiZhouPaiHangCell *)cell;
        if (mzph.itemOnClick == nil) {

            weakself(self);
            
            [mzph setItemOnClick:^(NSInteger index) {
                
                topicInfoModel *md =  weakSelf.modelArray[1];
                topicModel *topic = md.topics[index];
                
                WordsDetailViewController *wdVc = [WordsDetailViewController new];
                wdVc.wordsID = topic.ID.stringValue;
                
                [weakSelf.navigationController pushViewController:wdVc animated:YES];
                
            }];
        }
    }
    
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    topicInfoModel *md = [self.modelArray objectAtIndex:section];
    
    FindHeaderSectionView *head = [[FindHeaderSectionView alloc] init];
    
    head.title = md.title;
    
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.mainView.height * 0.05;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:return [self getCellHeightWithSection:1 withItemCount:3 WithScale:1.33];  //人气飙升
        case 1:return [self getCellHeightWithSection:3 withItemCount:1 WithScale:0.2]; //每周排行榜
        case 2:return [self getCellHeightWithSection:2 withItemCount:1 WithScale:0.4];  //新作出炉
        case 3:return [self getCellHeightWithSection:2 withItemCount:3 WithScale:1.33];  //主播力推
        case 4:return [self getCellHeightWithSection:1 withItemCount:2 WithScale:0.8];  //官方活动
    }
    
    return 0;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self hideNavBar:velocity.y > 0];
}

- (CGFloat)getCellHeightWithSection:(NSInteger)section withItemCount:(NSInteger)itemCount WithScale:(CGFloat)scale {
    
    CGFloat maxWidth    = self.mainView.width;
    CGFloat spaceing    = 10;
    
    CGFloat itemWidth  = (maxWidth - spaceing * (itemCount + 1))/itemCount;
    CGFloat CellHeight = (itemWidth * scale * section) + ((section + 1) * spaceing);
    
    return CellHeight;
}

#pragma mark 设置无线轮播器

- (void)setupPicScrollView {
    
    DCPicScrollViewConfiguration *pcv = [DCPicScrollViewConfiguration defaultConfiguration];
    
    pcv.pageAlignment = PageContolAlignmentCenter;
    pcv.itemConfiguration.contentMode =  UIViewContentModeScaleToFill;
    
    DCPicScrollView *ps = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.width, self.mainView.height * 0.4) withConfiguration:pcv withDataSource:self];
    
    ps.delegate = self;
    
    self.mainView.tableHeaderView = ps;
    
    self.bannerView = ps;
}

#pragma mark 无线轮播器代理方法

- (void)picScrollView:(DCPicScrollView *)picScrollView needUpdateItem:(DCPicItem *)item atIndex:(NSInteger)index {
    bannerModel *md = [self.bannerModelArray objectAtIndex:index];
    
    [item.imageView sd_setImageWithURL:[NSURL URLWithString:md.pic] placeholderImage:[UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"]];

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
