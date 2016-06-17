//
//  SearchHistoryView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/22.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SearchHistoryView.h"
#import "SearchHistoryCell.h"
#import "CommonMacro.h"

@interface SearchHistoryView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray<NSString *> *historyData;

@end

static NSString * const UserSearchHistoryDataKey = @"UserSearchHistoryDataKey";

@implementation SearchHistoryView


- (void)addHistory:(NSString *)history {

    //防止重复的历史信息
    
    __block BOOL isRepeat = NO;
    
    [self.historyData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        isRepeat = [obj isEqualToString:history];
        *stop    = isRepeat;
        
    }];
    
    if (isRepeat) return;
    
    [self.historyData insertObject:history atIndex:0];
    [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    self.tableFooterView.hidden = self.historyData.count < 3;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.historyData forKey:UserSearchHistoryDataKey];
    [ud synchronize];
    
}

- (void)setup {
    
    self.dataSource = self;
    self.delegate = self;
    self.rowHeight = 50;
    
    [self setupClearHistoryFooter];
}

- (void)setupClearHistoryFooter {
    
    UIButton *clearHistoryFooter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    clearHistoryFooter.titleLabel.font = [UIFont systemFontOfSize:15];
    clearHistoryFooter.layer.borderWidth = 3;
    clearHistoryFooter.layer.borderColor = subjectColor.CGColor;
    
    [clearHistoryFooter setTitleColor:subjectColor forState:UIControlStateNormal];
    [clearHistoryFooter setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    
    [clearHistoryFooter addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableFooterView = clearHistoryFooter;

    self.tableFooterView.hidden = YES;
}

- (void)clearHistory:(UIButton *)btn {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserSearchHistoryDataKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.historyData removeAllObjects];
    
    [self reloadData];
    
    self.tableFooterView.hidden = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell"];
    
    if (!cell) {
        
        cell = [[SearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchHistoryCell"];
        cell.tag = indexPath.row;
        
        weakself(self);
        
        [cell setDeleteBtnOnClick:^(SearchHistoryCell *deleteCell) {
            
            NSInteger index = deleteCell.tag;
            
            [weakSelf.historyData removeObjectAtIndex:index];
            [weakSelf deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            weakSelf.tableFooterView.hidden = self.historyData.count < 3;

        }];
    }
    
    cell.history = self.historyData[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.needSearchHistory) {
        self.needSearchHistory(self.historyData[indexPath.row]);
    }
}

- (NSMutableArray *)historyData {
    if (!_historyData) {
        
        NSMutableArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserSearchHistoryDataKey];
        _historyData = data.count > 0 ? data :[[NSMutableArray alloc] init];
    }
    return _historyData;
}
@end
