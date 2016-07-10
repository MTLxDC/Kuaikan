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

@interface FeedsTableView () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page_num;
}

@property (nonatomic,strong) FeedsDataModel *modelData;

@property (nonatomic) catalog_type dataType;

@property (nonatomic,strong) StatusCell *statusCell;

@property (nonatomic,strong) NSMutableArray *cellHeightCache;

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
        
        self.dataSource = self;
        self.delegate   = self;
        self.estimatedRowHeight = 200;
        
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
    
         self.mj_footer.hidden = NO;
        [self.mj_footer resetNoMoreData];
    
        NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/feed_lists?catalog_type=%zd&page_num=1&since=0&uid=0",self.dataType];
    
        weakself(self);
    
        [FeedsDataModel requestModelDataWithUrlString:url complish:^(id result) {
            
            [weakSelf.mj_header endRefreshing];
            
            FeedsDataModel *md = (FeedsDataModel *)result;
            
            if (!md) return ;
            
             weakSelf.modelData = md;
            [weakSelf.cellHeightCache removeAllObjects];
            [weakSelf reloadData];
            
        } cachingPolicy:ModelDataCachingPolicyReload hubInView:self];
    
}


- (void)loadMoreDate {
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/feed_lists?catalog_type=%zd&page_num=%zd&since=%zd&uid=0",self.dataType,_page_num,self.modelData.since.integerValue];
    
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
        [weakSelf reloadData];
        _page_num++;
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iOS8Later) return UITableViewAutomaticDimension;

    return [self getCellHeightWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [StatusCell configureCellWithModel:self.modelData inTableView:tableView AtIndexPath:indexPath];
}

- (CGFloat)getCellHeightWithIndexPath:(NSIndexPath *)indexPath {
    
    if (!_cellHeightCache) {
        _cellHeightCache = [[NSMutableArray alloc] init];
    }
    
    if (self.cellHeightCache.count > indexPath.row) {
        
        NSNumber *cacheHeight = self.cellHeightCache[indexPath.row];
        
        if (cacheHeight) return cacheHeight.doubleValue;
        
    }
    
    //实例一个Cell专门用来算高,如果是多个Cell,用字典,重用标识符做key,cell做value;
    
    StatusCell *cell = self.statusCell;
    
    cell.model = [self.modelData.feeds objectAtIndex:indexPath.row];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f,
                             CGRectGetWidth(self.bounds),
                             CGRectGetHeight(cell.bounds));
    
    // 得到cell的contentView需要的真实高度
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // 要为cell的分割线加上额外的1pt高度。因为分隔线是被加在cell底边和contentView底边之间的。
    height += 1.0f;
    
    [self.cellHeightCache addObject:@(height)];
    
    return height;
    
}

- (StatusCell *)statusCell {
    if (!_statusCell) {
        _statusCell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return _statusCell;
}

@end
