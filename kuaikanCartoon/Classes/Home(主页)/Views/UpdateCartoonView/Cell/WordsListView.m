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
#import "HomeViewController.h"

@interface WordsListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) wordsModel *words;

@property (nonatomic,weak) HomeViewController *myHomeVc;

@property (nonatomic,weak) UIImageView *hasNotBeenUpdatedView;


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
    self.rowHeight = 260;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weakself(self);
    
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf updateWithUrl:self.urlString CachingPolicy:ModelDataCachingPolicyReload];
    }];
    
    [normalHeader.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
    
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        NSString *url = [NSString stringWithFormat:@"%@?since=%zd",self.urlString,self.words.since.integerValue];
        
        [wordsModel requestModelDataWithUrlString:url complish:^(id result) {
            
            wordsModel *md = (wordsModel *)result;
            
            [weakSelf.mj_footer endRefreshing];
            
            if (!result) return ;
            
            if (md.comics.count < 1) {
                [weakSelf.tableFooterView setHidden:NO];
                return ;
            }

            [weakSelf.words.comics addObjectsFromArray:md.comics];
             weakSelf.words.since = md.since;
            
            [weakSelf reloadData];
            
        } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self];
        
    }];
    
    
    self.mj_header = normalHeader;
    
    self.mj_footer = footer;
    
    UIImage *image = [UIImage imageNamed:@"no_data_footer_375x98_"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self.tableFooterView = imageView;
    self.tableFooterView.hidden = YES;
    
    UIImageView *hasNotBeenUpdatedView = [[UIImageView alloc] init];
    
    hasNotBeenUpdatedView.image = [UIImage imageNamed:@"6_clock_191x234_"];
    hasNotBeenUpdatedView.hidden = YES;
    
    [self addSubview:hasNotBeenUpdatedView];
    
    self.hasNotBeenUpdatedView = hasNotBeenUpdatedView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.hasNotBeenUpdatedView.frame  = CGRectMake(50,self.center.y, 191, 234);
    self.hasNotBeenUpdatedView.center = self.center;
    
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
    return 12;
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
        
    [self.myHomeVc.navigationController pushViewController:detailVc animated:YES];
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    [self.myHomeVc hideNavBar:velocity.y > 0];
    
}


- (void)updateWithUrl:(NSString *)url CachingPolicy:(ModelDataCachingPolicy)policy{
    
    self.tableFooterView.hidden = YES;
    self.words = nil;
    [self reloadData];
    
    weakself(self);
    
    [wordsModel requestModelDataWithUrlString:url complish:^(id res) {
        
        WordsListView *sself = weakSelf;
        
        if (!sself) return;
        
        [sself.mj_header endRefreshing];

        if (!res) return ;
        
        sself.words = res;

        if (sself.words.comics.count < 1) {
            if (self.NoDataCallBack) {
                self.NoDataCallBack();
            }
            return ;
        }
        
            [sself reloadData];
            [sself layoutIfNeeded];
            [sself setContentOffset:CGPointZero];
        
    } cachingPolicy:policy hubInView:self.superview];
    
    
}

- (void)setHasNotBeenUpdated:(BOOL)hasNotBeenUpdated {
    _hasNotBeenUpdated = hasNotBeenUpdated;
    self.hasNotBeenUpdatedView.hidden = !hasNotBeenUpdated;
    self.mj_footer.hidden = hasNotBeenUpdated;
}

- (void)setUrlString:(NSString *)urlString {

    [self updateWithUrl:urlString CachingPolicy:ModelDataCachingPolicyDefault];
    
    _urlString = urlString;

}

- (HomeViewController *)myHomeVc {
    if (!_myHomeVc) {
        _myHomeVc = [self findResponderWithClass:[HomeViewController class]];
    }
    return _myHomeVc;
}

@end





