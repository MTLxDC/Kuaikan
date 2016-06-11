//
//  MyMessageViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageCell.h"
#import "ReplyDataModel.h"

@interface MyMessageViewController ()

@property (nonatomic,strong) ReplyDataModel *model;

@property (nonatomic,strong) MyMessageCell  *meesageCell;

@property (nonatomic,strong) NSMutableArray *cellHeightCache;

@end



@implementation MyMessageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.cellHeightCache = [NSMutableArray array];
        self.meesageCell = [MyMessageCell makeMyMessageCell];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    self.tableView.estimatedRowHeight = SCREEN_HEIGHT * 0.33;
    
    [self updata];
    
    
}


- (void)updata {

    NSString *url = @"http://api.kuaikanmanhua.com/v1/comments/replies/timeline?since=0";
    
    weakself(self);
    
    [ReplyDataModel requestModelDataWithUrlString:url complish:^(id result) {
        
         weakSelf.model = result;
         weakSelf.tableView.mj_footer.hidden = weakSelf.model.since.integerValue == 0;
        [weakSelf.cellHeightCache removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyReload hubInView:self.view];
        
}

- (void)loadMoreData {
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comments/replies/timeline?since=%zd",self.model.since.integerValue];
    
    weakself(self);
    
    [ReplyDataModel requestModelDataWithUrlString:url complish:^(id result) {
        
        ReplyDataModel *resultModel = (ReplyDataModel *)result;
        
        if (resultModel.comments.count < 1) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [weakSelf.model.comments addObjectsFromArray:resultModel.comments];
         weakSelf.model.since = resultModel.since;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MyMessageCellIdentifier];
    
    if (!cell) {
        cell = [MyMessageCell makeMyMessageCell];
    }
    
    cell.model = [self.model.comments objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (iOS8Later) return UITableViewAutomaticDimension;
  
    if (self.cellHeightCache.count > indexPath.row) {
        
        NSNumber *cacheHeight = self.cellHeightCache[indexPath.row];
        
        if (cacheHeight) return cacheHeight.doubleValue;
        
    }
    
    //实例一个Cell专门用来算高,如果是多个Cell,用字典,重用标识符做key,cell做value;
    
    MyMessageCell *cell = self.meesageCell;
    
    cell.model = self.model.comments[indexPath.row];
    
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


@end
