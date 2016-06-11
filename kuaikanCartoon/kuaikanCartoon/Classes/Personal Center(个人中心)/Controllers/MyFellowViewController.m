//
//  MyFellowViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyFellowViewController.h"
#import "MyFellowWordsCell.h"
#import "FellowTopicsModel.h"
#import "WordsDetailViewController.h"

@interface MyFellowViewController ()

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) NSInteger limit;

@property (nonatomic,assign) NSInteger offset;

@end

@implementation MyFellowViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.limit  = 20;
        self.offset = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 80;
    self.title = @"我的关注";
    
    [self updata];
}

- (void)updata {
    
    NSString *url = @"http://api.kuaikanmanhua.com/v1/fav/topics?limit=20&offset=0";
    
    weakself(self);
    
    [FellowTopicsModel requestModelDataWithUrlString:url complish:^(id result) {
        
         weakSelf.modelArray = result;
         weakSelf.tableView.mj_footer.hidden = weakSelf.modelArray.count < 20;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyReload hubInView:self.view];
    
}

- (void)loadMoreData {
    
    self.limit  += 20;
    self.offset += 20;
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/fav/topics?limit=%zd&offset=%zd",self.limit,self.offset];
    
    weakself(self);
    
    [FellowTopicsModel requestModelDataWithUrlString:url complish:^(id result) {
        
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
    
    MyFellowWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFellowWordsCellName];
    
    if (!cell) {
        cell = [MyFellowWordsCell makeMyFellowWordsCell];
    }
    
    cell.model = self.modelArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FellowTopicsModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    WordsDetailViewController *wdVc = [[WordsDetailViewController alloc] init];
    
    wdVc.wordsID = model.ID.stringValue;
    
    [self.navigationController pushViewController:wdVc animated:YES];
}



@end
