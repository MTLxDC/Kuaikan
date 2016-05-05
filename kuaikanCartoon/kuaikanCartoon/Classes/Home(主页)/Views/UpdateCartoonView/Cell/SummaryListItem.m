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
        
        
    }];
    
    [normalHeader.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
    
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
    
    
    self.mj_header = normalHeader;
    
    self.mj_footer = footer;
    
    UIImage *image = [UIImage imageNamed:@"no_data_footer_375x98_"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self.tableFooterView = imageView;
    
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


- (void)updata:(NSString *)url {
    
    weakself(self);
    
    [SummaryModel requestSummaryModelDataWithUrlString:self.urlString complish:^(id res) {
        
    
        [weakSelf.mj_header endRefreshing];

    } useCache:NO];
    
}

- (void)setUrlString:(NSString *)urlString {
    
    _urlString = urlString;
    weakself(self);

    [SummaryModel requestSummaryModelDataWithUrlString:_urlString complish:^(id res) {
        
        if ([res isKindOfClass:[NSError class]] || res == nil || weakSelf == nil) {
            DEBUG_Log(@"%@",res);
            return ;
        }
        
        weakSelf.modelArray = res;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadData];
        });
        
    } useCache:YES];
    
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
