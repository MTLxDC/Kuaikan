//
//  MyMessageViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageCell.h"
#import "ReplyCommentsModel.h"

@interface MyMessageViewController ()

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,strong) MyMessageCell  *meesageCell;

@property (nonatomic,strong) NSMutableArray *cellHeightCache;

@property (nonatomic,assign) NSInteger since;

@end



@implementation MyMessageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.modelArray = [NSMutableArray array];
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
    
    [ReplyCommentsModel requestModelDataWithUrlString:url complish:^(id result) {
        
         weakSelf.modelArray = result;
        [weakSelf.cellHeightCache removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyDefault];
        
}

- (void)loadMoreData {
    
    self.since += 20;
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comments/replies/timeline?since=%zd",self.since];
    
    weakself(self);
    
    [ReplyCommentsModel requestModelDataWithUrlString:url complish:^(id result) {
        
        NSArray *resultArr = (NSArray *)result;
        
        if (resultArr.count < 1) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [weakSelf.modelArray addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyDefault];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MyMessageCellIdentifier];
    
    if (!cell) {
        cell = [MyMessageCell makeMyMessageCell];
    }
    
    cell.model = [self.modelArray objectAtIndex:indexPath.row];
    
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
    
    cell.model = self.modelArray[indexPath.row];
    
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
