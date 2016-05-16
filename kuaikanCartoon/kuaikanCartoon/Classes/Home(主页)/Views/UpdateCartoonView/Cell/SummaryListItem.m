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
#import "SummaryModel.h"

@interface SummaryListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *modelArray;

@end


@implementation SummaryListView

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
    self.rowHeight = 300;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weakself(self);
    
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf updateWithUrl:self.urlString CachingPolicy:ModelDataCachingPolicyReload];
    }];
    
    [normalHeader.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
    
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
    
    
    self.mj_header = normalHeader;
    
    self.mj_footer = footer;
    
    UIImage *image = [UIImage imageNamed:@"no_data_footer_375x98_"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self.tableFooterView = imageView;
    
    self.tableFooterView.hidden = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= scrollView.contentSize.height) {
        self.tableHeaderView.hidden = NO;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartoonSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [CartoonSummaryCell cartoonSummaryCell];
    }
    
    cell.model = [self.modelArray objectAtIndex:indexPath.row];
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartoonDetailViewController *detailVc = [[CartoonDetailViewController alloc] init];
    
    SummaryModel *md = self.modelArray[indexPath.row];
    
    detailVc.cartoonId = [NSString stringWithFormat:@"%zd",md.ID.integerValue];
    
    [[self findResponderWithClass:[UINavigationController class]]
               pushViewController:detailVc animated:YES];
}


- (void)updateWithUrl:(NSString *)url CachingPolicy:(ModelDataCachingPolicy)policy{
    
    weakself(self);
    
    
    [SummaryModel requestModelDataWithUrlString:url complish:^(id res) {
        
        if (weakSelf == nil) return ;
        
        SummaryListView *sself = weakSelf;
        
            sself.modelArray = res;
            [sself reloadData];
            [sself.mj_header endRefreshing];
        
    } cachingPolicy:policy];
    
    
}

- (void)setUrlString:(NSString *)urlString {
    
    [self updateWithUrl:urlString CachingPolicy:ModelDataCachingPolicyDefault];
    
    _urlString = urlString;

}

@end

/* SummaryListItem  */

@interface SummaryListItem ()

@property (nonatomic,weak) SummaryListView *slv;

@end

@implementation SummaryListItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        SummaryListView *slv = [[SummaryListView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self.contentView addSubview:slv];
        
        self.slv = slv;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.slv.frame = self.bounds;
    
}

- (void)setUrlString:(NSString *)urlString {
    self.slv.urlString = urlString;
}



@end
