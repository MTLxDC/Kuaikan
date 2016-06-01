//
//  SummaryListItem.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SummaryListItem.h"
#import "CartoonSummaryCell.h"
#import "CommonMacro.h"
#import <MJRefresh.h>
#import "UIView+Extension.h"
#import "CartoonDetailViewController.h"
#import "wordsModel.h"
#import "DateManager.h"

@interface WordsListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) wordsModel *words;

@property (nonatomic,weak) UINavigationController *myNav;

@property (nonatomic,assign) NSInteger since;


@end



@implementation WordsListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (!self) return nil;
    
    [self setup];
    
    
    return self;
}

static NSString * const cellIdentifier = @"SummaryCell";

- (void)setup {
    
    self.dataSource = self;
    self.delegate = self;
    self.rowHeight = 282;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.since = 0;
    
    weakself(self);
    
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf updateWithUrl:self.urlString CachingPolicy:ModelDataCachingPolicyReload];
    }];
    
    [normalHeader.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
    
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        self.since += 20;
        
        NSString *url = [NSString stringWithFormat:@"%@?since=%zd",self.urlString,self.since];
        
        [wordsModel requestModelDataWithUrlString:url complish:^(id result) {
            
            
            wordsModel *md = (wordsModel *)result;
            
            if (md.comics.count < 1) {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
                return ;
            }

            
            [weakSelf.words.comics addObjectsFromArray:md.comics];
             weakSelf.words.since = md.since;
            
            [weakSelf reloadData];
            
            [weakSelf.mj_footer endRefreshing];
            
        } cachingPolicy:ModelDataCachingPolicyNoCache];
        
    }];
    
    
    self.mj_header = normalHeader;
    
    self.mj_footer = footer;
    
    UIImage *image = [UIImage imageNamed:@"no_data_footer_375x98_"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self.tableFooterView = imageView;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.words.comics.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartoonSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [CartoonSummaryCell cartoonSummaryCell];
    }
    
    cell.model = [self.words.comics objectAtIndex:indexPath.section];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *line = [[UIView alloc] initWithFrame:self.bounds];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return line;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.hasTimeline ? 50 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.hasTimeline == NO) return [[UIView alloc] initWithFrame:self.bounds];
    
    UIButton *timeLineHeadView = [[UIButton alloc] initWithFrame:self.bounds];
    
    [timeLineHeadView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [timeLineHeadView setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [timeLineHeadView setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [timeLineHeadView setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [timeLineHeadView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
     timeLineHeadView.titleLabel.font = [UIFont systemFontOfSize:13];
     timeLineHeadView.userInteractionEnabled = NO;
    
    [timeLineHeadView setImage:[UIImage imageNamed:@"ic_home_date_17x17_"] forState:UIControlStateNormal];
    
    SummaryModel *md = [self.words.comics objectAtIndex:section];
    
    NSString *updateTime = [[DateManager share] conversionDateVer2:[NSDate dateWithTimeIntervalSince1970:md.updated_at.doubleValue]];
    
    [timeLineHeadView setTitle:updateTime forState:UIControlStateNormal];
    
    return timeLineHeadView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartoonDetailViewController *detailVc = [[CartoonDetailViewController alloc] init];
    
    SummaryModel *md = self.words.comics[indexPath.section];
    
    detailVc.cartoonId = md.ID.stringValue;
    
    NSLog(@"%zd",indexPath.row);
    
    [[self findResponderWithClass:[UINavigationController class]]
               pushViewController:detailVc animated:YES];
}



- (void)updateWithUrl:(NSString *)url CachingPolicy:(ModelDataCachingPolicy)policy{
    
    
    weakself(self);
    
    [wordsModel requestModelDataWithUrlString:url complish:^(id res) {
        
        if (weakSelf == nil) return ;
        
        WordsListView *sself = weakSelf;
        
        [sself.mj_header endRefreshing];
        
        if (res == nil) return;
    
            sself.words = res;
            [sself reloadData];
            sself.hidden = NO;
        
    } cachingPolicy:policy];
    
    
}

- (void)setUrlString:(NSString *)urlString {
    
    self.hidden = YES;
    [self updateWithUrl:urlString CachingPolicy:ModelDataCachingPolicyDefault];
    
    _urlString = urlString;

}

- (UINavigationController *)myNav {
    if (!_myNav) {
        _myNav = [self findResponderWithClass:[UINavigationController class]];
    }
    return _myNav;
}


@end





