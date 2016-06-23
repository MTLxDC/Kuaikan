//
//  SearchTableViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/19.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomSearchBar.h"
#import <Masonry.h>
#import "CommonMacro.h"

#import "SearchHistoryView.h"
#import "NoResultTipView.h"

#import <MJRefresh.h>
#import "SearchResultsCell.h"
#import "searchWordModel.h"
#import "WordsDetailViewController.h"

@interface SearchViewController () <CustomSearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *searchResultsView;

@property (nonatomic,weak) SearchHistoryView *historyView;

@property (nonatomic,weak) CustomSearchBar *searchBar;

@property (nonatomic,weak) NoResultTipView *noResultTipView;

@property (nonatomic,strong) NSMutableArray *wordModelArray;

@property (nonatomic,assign) BOOL showHistory;

@property (nonatomic,strong) NSMutableArray *historyData;

@property (nonatomic,copy) NSString *currentSeachText;


@end

static NSString * const searchBaseUrl = @"http://api.kuaikanmanhua.com/v1/topics/search";

@implementation SearchViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupSeachBar];
    
    [self setupSearchResultsView];
    
    [self setupSearchHistoryView];
    
    [self setupNoResultTipView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}


#pragma mark 设置子视图

- (void)setupSeachBar {
    
    CustomSearchBar *searchBar = [CustomSearchBar makeCustomSearchBar];
    
    [self.view addSubview:searchBar];
    
    searchBar.delegate = self;
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(navHeight));
    }];
    
    self.searchBar = searchBar;
}

- (void)setupSearchResultsView {
    
    UITableView *tableView = [UITableView new];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHeight);
    }];
    
    tableView.rowHeight = cellHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    tableView.mj_footer.hidden = YES;
    
    self.searchResultsView = tableView;
}

static NSInteger limit  = 20;
static NSInteger offset = 0;

- (void)loadMoreData {
    
    offset += 20;

    NSString *urlString = [NSString stringWithFormat:@"%@?keyword=%@&limit=%zd&offset=%zd",searchBaseUrl,self.currentSeachText,limit,offset];
    
    weakself(self);
    
    [searchWordModel requestModelDataWithUrlString:urlString complish:^(id result) {
        
        NSMutableArray *resultArr = (NSMutableArray *)result;
        
        if (resultArr.count < 1) {
            [weakSelf.searchResultsView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [weakSelf.wordModelArray addObjectsFromArray:resultArr];
        [weakSelf.searchResultsView reloadData];
        [weakSelf.searchResultsView.mj_footer endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view];
    
    
}

- (void)setupNoResultTipView {
    
    NoResultTipView *tipView = [NoResultTipView new];
    
    [self.view addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHeight);
    }];
    
    tipView.hidden = YES;
    
    self.noResultTipView = tipView;
}

- (void)setupSearchHistoryView {
    
    weakself(self);
    
    SearchHistoryView *historyView = [SearchHistoryView new];
    [self.view addSubview:historyView];
    
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHeight);
    }];
    
    [historyView setNeedSearchHistory:^(NSString *needSearchText) {
        [weakSelf.searchBar changeSearchText:needSearchText];
    }];
    
    self.historyView = historyView;
}

- (void)setShowHistory:(BOOL)showHistory {
    _showHistory = showHistory;
    self.historyView.hidden = !showHistory;
}

- (void)searchText:(NSString *)text {
    
    self.showHistory = text.length < 1;
    
    if (self.showHistory || text.length > 12) return;
    
    //清空格
    self.currentSeachText = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //转UTF-8
    NSString *keyword   = [self.currentSeachText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?keyword=%@&limit=%d&offset=%d",searchBaseUrl,keyword,20,0];
    
    weakself(self);
    
    [searchWordModel requestModelDataWithUrlString:urlString complish:^(id result) {
     
        weakSelf.wordModelArray = result;
        
        BOOL hasResult = weakSelf.wordModelArray.count > 0;
        
        weakSelf.noResultTipView.hidden = hasResult;
        weakSelf.searchResultsView.hidden = !hasResult;
        
        if (hasResult) {
             weakSelf.searchResultsView.mj_footer.hidden = NO;
            [weakSelf.searchResultsView reloadData];
        }
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view];
    
    
}

#pragma mark SearchBarDelegate

- (void)customSearchBarDidBeginEditing:(CustomSearchBar *)searchBar {
}

- (void)customSearchBar:(CustomSearchBar *)searchBar textDidChange:(NSString *)text {
    [self searchText:text];
}

- (void)customSearchBarNeedDisMiss:(CustomSearchBar *)searchBar {
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    searchWordModel *wordModel = self.wordModelArray[indexPath.row];
    
    WordsDetailViewController *wd = [[WordsDetailViewController alloc] init];
    
    wd.wordsID = wordModel.ID.stringValue;
    
    [self.navigationController pushViewController:wd animated:YES];
    
    [self.historyView addHistory:self.currentSeachText];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchResultsCell makeSearchResultsCellWithTableView:tableView WithTopicModel:self.wordModelArray[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordModelArray.count;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

@end
