//
//  FeedsTableView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "FeedsTableView.h"
#import <MJRefresh.h>
#import "FeedsDataModel.h"
#import "CommonMacro.h"
#import "StatusCell.h"

#import "UIView+Extension.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "AuthorStatusDetailViewController.h"


@interface FeedsTableView () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page_num;
}

@property (nonatomic,strong) FeedsDataModel *modelData;

@property (nonatomic) catalog_type dataType;

@end



@implementation FeedsTableView

- (void)updateWithDataType:(catalog_type)dataType {
    self.dataType = dataType;
}

- (void)setDataType:(catalog_type)dataType {
    _dataType = dataType;
    [self.mj_header beginRefreshing];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _page_num = 1;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 200;
        
        [self registerClass:[StatusCell class] forCellReuseIdentifier:statusCellReuseIdentifier];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(update)];
        
        [header.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
        
        self.mj_header = header;
        self.mj_footer = footer;
        self.mj_footer.hidden = YES;
        
    }
    return self;
}

- (void)update {
    
     [self.mj_footer resetNoMoreData];

    NSString *url = nil;
    
    if (self.dataType == usersConcernedData) {
        url = @"http://api.kuaikanmanhua.com/v1/feeds/following/feed_lists?since=0";
    }else {
        url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/feed_lists?catalog_type=%zd&page_num=1&since=0&uid=0",self.dataType];
    }
    
        weakself(self);
    
        [FeedsDataModel requestModelDataWithUrlString:url complish:^(id result) {
            
            [weakSelf.mj_header endRefreshing];
            
            FeedsDataModel *md = (FeedsDataModel *)result;
            
            if (!md) return ;
            
             weakSelf.mj_footer.hidden = NO;
             weakSelf.modelData = md;
             [weakSelf reloadData];
            
        } cachingPolicy:ModelDataCachingPolicyReload hubInView:self];
    
}


- (void)loadMoreDate {
    
    NSString *url = nil;
    
    if (self.dataType == usersConcernedData) {
        url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/following/feed_lists?since=%@",self.modelData.since];
    }else {
        url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/feed_lists?catalog_type=%zd&page_num=%zd&since=%@&uid=0",self.dataType,_page_num,self.modelData.since];
    }
    
    weakself(self);
    
    [FeedsDataModel requestModelDataWithUrlString:url complish:^(id result) {
        
        [weakSelf.mj_footer endRefreshing];
        
        FeedsDataModel *md = (FeedsDataModel *)result;
        
        if (md.feeds.count < 1) {
            [weakSelf.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [weakSelf.modelData.feeds addObjectsFromArray:md.feeds];
         weakSelf.modelData.since = md.since;
        [weakSelf fd_reloadDataWithoutInvalidateIndexPathHeightCache];
        _page_num++;
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self fd_heightForCellWithIdentifier:statusCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        
        StatusCell *cell1 = (StatusCell *)cell;
        
        cell1.model = self.modelData.feeds[indexPath.row];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:statusCellReuseIdentifier];
    
    cell.showFollowBtn = YES;
    cell.model = [self.modelData.feeds objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FeedsModel *model  = [self.modelData.feeds objectAtIndex:indexPath.row];
    
    CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    AuthorStatusDetailViewController *asdVc = [[AuthorStatusDetailViewController alloc] initWithFeedsModel:model WithCellHeight:cellHeight];
    
    [self.myViewController.navigationController pushViewController:asdVc animated:YES];
}


@end
