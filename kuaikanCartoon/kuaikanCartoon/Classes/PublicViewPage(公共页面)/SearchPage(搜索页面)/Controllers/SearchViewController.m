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

#import "SearchResultsCell.h"
#import "searchWordModel.h"
#import "WordsDetailViewController.h"

@interface SearchViewController () <CustomSearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *searchResultsView;

@property (nonatomic,weak) SearchHistoryView *historyView;

@property (nonatomic,weak) CustomSearchBar *searchBar;

@property (nonatomic,weak) NoResultTipView *noResultTipView;


@property (nonatomic,strong) NSArray *wordModelArray;

@property (nonatomic,assign) BOOL showHistory;

@property (nonatomic,strong) NSMutableArray *historyData;

@property (nonatomic,copy) NSString *currentSeachText;


@end

static NSString * const searchBaseUrl = @"http://api.kuaikanmanhua.com/v1/topics/search";

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    self.searchResultsView = tableView;
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
    
    SearchHistoryView *historyView = [SearchHistoryView new];
    [self.view addSubview:historyView];
    
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHeight);
    }];
    
    [historyView setNeedSearchHistory:^(NSString *needSearchText) {
       
        [self.searchBar changeSearchText:needSearchText];
        
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
    
    self.currentSeachText = text;
    
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?keyword=%@&limit=%zd&offset=%zd",searchBaseUrl,text,20,0];
    
    weakself(self);
    
    [searchWordModel requestModelDataWithUrlString:urlString complish:^(id result) {
     
        weakSelf.wordModelArray = result;
        
        BOOL hasResult = weakSelf.wordModelArray.count > 0;
        
        weakSelf.noResultTipView.hidden = hasResult;
        weakSelf.searchResultsView.hidden = !hasResult;
        
        if (hasResult) {
            [weakSelf.searchResultsView reloadData];
        }
        
    } cachingPolicy:ModelDataCachingPolicyNoCache];
    
    
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
