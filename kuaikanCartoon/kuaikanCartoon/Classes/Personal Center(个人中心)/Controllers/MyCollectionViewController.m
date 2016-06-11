//
//  MyCollectionViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionCell.h"
#import "CollectionComicModel.h"
#import "CommonMacro.h"
#import "CartoonDetailViewController.h"

@interface MyCollectionViewController ()

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) NSInteger limit;

@property (nonatomic,assign) NSInteger offset;


@end

@implementation MyCollectionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modelArray = [[NSMutableArray alloc] init];
        self.limit  = 20;
        self.offset = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 80;
    self.title = @"我的收藏";
    
    [self updata];
    
}


- (void)updata {
    
    NSString *url = @"http://api.kuaikanmanhua.com/v1/fav/comics?limit=20&offset=0";
    
    weakself(self);
    
    [CollectionComicModel requestModelDataWithUrlString:url complish:^(id result) {
        
        weakSelf.tableView.mj_footer.hidden = weakSelf.modelArray.count < 20;
         weakSelf.modelArray = result;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyReload hubInView:self.view];
    
}



- (void)loadMoreData {
    
    self.limit  += 20;
    self.offset += 20;
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/fav/comics?limit=%zd&offset=%zd",self.limit,self.offset];
    
    weakself(self);
    
    [CollectionComicModel requestModelDataWithUrlString:url complish:^(id result) {
        
        NSArray *resultArr = (NSArray *)result;
        
        if (resultArr.count < 1) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [weakSelf.modelArray addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCollectionCellIdentifier];
    
    if (!cell) {
        cell = [MyCollectionCell makeMyCollectionCell];
    }
    
    cell.model = self.modelArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionComicModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    CartoonDetailViewController *cdVc = [[CartoonDetailViewController alloc] init];
    
    cdVc.cartoonId = model.ID.stringValue;
    
    [self.navigationController pushViewController:cdVc animated:YES];
}



@end
