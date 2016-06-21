//
//  AuthorInfoViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/17.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorInfoViewController.h"
#import "WordsDetailViewController.h"

#import "AuthorInfoDetailHeadView.h"
#import <Masonry.h>
#import "UIView+Extension.h"
#import "AuthorInfoModel.h"
#import "UrlStringDefine.h"
#import "CommonMacro.h"
#import "AuthorShareInfoCell.h"
#import "AuthorTopicInfoCell.h"
#import "ProgressHUD.h"

@interface AuthorInfoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,weak) AuthorInfoDetailHeadView *headView;

@property (nonatomic,strong) AuthorInfoModel *model;

@property (nonatomic,strong) NSArray<NSString *> *shareText;

@end

@implementation AuthorInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViewAndHeadView];
    
    [self requstData];
}

- (void)requstData {
    
    NSString *url = [NSString stringWithFormat:AuthorInfoUrlStringFormat,self.authorID];
    
    weakself(self);
    
    [AuthorInfoModel requestModelDataWithUrlString:url complish:^(id result) {
        
        AuthorInfoModel *md = (AuthorInfoModel *)result;
        
        if (!md) return;
        
        weakSelf.model = md;
        weakSelf.headView.model = md;
       [weakSelf.tableView reloadData];
        
        
    } cachingPolicy:ModelDataCachingPolicyDefault hubInView:self.view];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)setupTableViewAndHeadView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate   = self;
    tableView.contentInset = UIEdgeInsetsMake(AuthorInfoDetailHeadViewHeight, 0, 0, 0);
    
    [tableView registerClass:[AuthorTopicInfoCell class] forCellReuseIdentifier:AuthorTopicInfoCellReuseIdentifier];
    
    [tableView registerClass:[AuthorShareInfoCell class] forCellReuseIdentifier:AuthorShareInfoCellIdentifier];
    
    AuthorInfoDetailHeadView *headView = [AuthorInfoDetailHeadView makeAuthorInfoDetailHeadView];
    
    [self.view addSubview:tableView];
    [self.view addSubview:headView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(AuthorInfoDetailHeadViewHeight));
    }];
    
    _tableView = tableView;
    _headView  = headView;
    
}

#pragma mark -cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AuthorShareInfoCellHeight;
    }else if (indexPath.section == 1) {
        return AuthorTopicInfoCellHeight;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        AuthorShareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorShareInfoCellIdentifier];
        
        NSInteger index = indexPath.row;
        
        [cell setText:self.shareText[index] atIndex:index];
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
        AuthorTopicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorTopicInfoCellReuseIdentifier];
        
        cell.model = self.model.topics[indexPath.row];
        
        return cell;
        
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.shareText.count;
    }else if(section == 1) {
        return self.model.topics.count;
    }
    
    return 0;
}

#pragma mark - tableDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        
        if (row < 2) {
            
            NSString *text = self.shareText[row];
            [[UIPasteboard generalPasteboard] setString:text];
            [ProgressHUD showSuccessWithStatus:@"复制成功" inView:self.view];
            
        }else if(row == 2) {
            
            
        }else if (row == 3) {
            
            NSString *urlString = self.shareText[row];
            
           urlString = [urlString stringByReplacingOccurrencesOfString:@"https://" withString:@"itms-apps://"];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            UIApplication *app = [UIApplication sharedApplication];
            
            if (![app canOpenURL:url]) {
                DEBUG_Log(@"跳转失败,非法url:%@",url);
                return;
            }
            
            BOOL succeed = [app openURL:url];
            
            if (!succeed) {
                [ProgressHUD showErrorWithStatus:@"跳转AppStore失败" inView:self.view];
            }
            
        }
        
    }else if (section == 1) {
        
        topicModel *md = self.model.topics[indexPath.row];

        WordsDetailViewController *wdVc = [[WordsDetailViewController alloc] init];
        
        wdVc.wordsID = md.ID.stringValue;
        
        [self.navigationController pushViewController:wdVc animated:YES];
        
    }
    
}


#pragma mark - sectionHeader

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) return 30;
    
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *sectionHeadView = [[UIView alloc] initWithFrame:self.view.bounds];
        sectionHeadView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [UILabel new];
        
        label.text = @"TA的作品";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkGrayColor];
        
        [sectionHeadView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionHeadView).offset(8);
            make.top.bottom.equalTo(sectionHeadView);
        }];
        
        return sectionHeadView;
        
    }
    
    return [[UIView alloc] initWithFrame:self.view.bounds];
    
}

#pragma mark - sectionFooter

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        UIView *spaceLine = [[UIView alloc] initWithFrame:self.view.bounds];
        
        spaceLine.backgroundColor = [UIColor clearColor];
        
        return spaceLine;
    }
    
    return [[UIView alloc] initWithFrame:self.view.bounds];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) return 10;
    
    return 0.01;
}

#pragma mark - scrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = -scrollView.contentOffset.y;
    
    if (offsetY <= navHeight) offsetY = navHeight;
    
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(offsetY));
    }];
    
    [self.headView layoutIfNeeded];
}


#pragma mark - lazy load

//1.微博 //2.微信 //3.一个主页链接 //4.appstore下载应用的链接

- (NSArray<NSString *> *)shareText {
    
    if (!_shareText && self.model) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        NSString *weibo  = self.model.weibo_name;
        NSString *wechat = self.model.wechat;
        NSString *site   = self.model.site;
        NSString *ios    = self.model.ios;
        
        if (weibo.length)  [arr addObject:weibo];
        if (wechat.length) [arr addObject:wechat];
        if (site.length)   [arr addObject:site];
        if (ios.length)    [arr addObject:ios];

        _shareText = [arr copy];
    }
    
    return _shareText;
}

@end
