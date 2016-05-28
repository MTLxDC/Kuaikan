//
//  CommentDetailView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentDetailView.h"
#import "CommentInfoCell.h"
#import "CommentDetailModel.h"
#import "CommonMacro.h"
#import "UIView+Extension.h"
#import <MJRefresh.h>

@interface CommentDetailView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) CommentDetailModel *modelData;

@property (nonatomic,strong) NSMutableArray *cellHeightCache;

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;


@end




@implementation CommentDetailView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setRequestUrlWithIsNew:(BOOL)isNew withRequestUrl:(NSString *)requestID {
    
    NSString *requestFormat = isNew ? newCommentRequestUrlFormat : hotCommentRequestUrlFormat;
    
    NSString *requestUrl = [NSString stringWithFormat:requestFormat,requestID];
    
    self.requestUrl = requestUrl;

    
}


- (void)setup {
    
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.cellHeightCache = [NSMutableArray array];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.mj_footer beginRefreshing];
        
        NSString *moreCommentUrl = [self.requestUrl stringByReplacingOccurrencesOfString:@"0" withString:self.modelData.since.stringValue];
        
        weakself(self);
        
        [CommentDetailModel requestModelDataWithUrlString:moreCommentUrl complish:^(id res) {

            CommentDetailModel *md = (CommentDetailModel *)res;
            
            if (md.comments.count < 1) {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
                return ;
            };
            
            [weakSelf.modelData.comments addObjectsFromArray:md.comments];
             weakSelf.modelData.since = md.since;
            [weakSelf reloadData];
            
            [weakSelf.mj_footer endRefreshing];
            
        } cachingPolicy:ModelDataCachingPolicyNoCache];
        
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.cellHeightCache.count > indexPath.row) {
        
        NSNumber *cacheHeight = self.cellHeightCache[indexPath.row];
        
        if (cacheHeight) return cacheHeight.doubleValue;
        
    }
    
    CommentInfoCell *cell = [self.offscreenCells objectForKey:commentInfoCellName];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentInfoCell" owner:nil options:nil] firstObject];
        [self.offscreenCells setObject:cell forKey:commentInfoCellName];
    }
    
    cell.commentsModel = self.modelData.comments[indexPath.row];
    
     [cell setNeedsLayout];
     [cell layoutIfNeeded];
    
      cell.bounds = CGRectMake(0.0f, 0.0f,
                               CGRectGetWidth(tableView.bounds),
                               CGRectGetHeight(cell.bounds));
    
     // 得到cell的contentView需要的真实高度
     CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
     
     // 要为cell的分割线加上额外的1pt高度。因为分隔线是被加在cell底边和contentView底边之间的。
     height += 1.0f;
    
    [self.cellHeightCache addObject:@(height)];
     
     return height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellName];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentInfoCell" owner:nil options:nil] firstObject];
    }
    
    cell.commentsModel = self.modelData.comments[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)setRequestUrl:(NSString *)requestUrl {
    _requestUrl = requestUrl;
    [self update];
}

- (void)update {
    
    self.hidden = YES;
    
    weakself(self);
    
    [CommentDetailModel requestModelDataWithUrlString:self.requestUrl complish:^(id res) {
        if (weakSelf == nil) {
            return ;
        }
        
        CommentDetailView *sself = weakSelf;
            sself.modelData = res;
            [sself.cellHeightCache removeAllObjects];
            [sself reloadData];
            [sself setContentOffset:CGPointMake(0, -navHeight)];
             sself.hidden = NO;
        
    } cachingPolicy:ModelDataCachingPolicyNoCache] ;
    
}





@end
