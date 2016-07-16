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

#import <MJRefreshAutoNormalFooter.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import "StatusCell.h"
#import "FeedsDataModel.h"
#import "wordsOptionsHeadView.h"
#import "AuthorProfileView.h"

typedef enum : NSUInteger {
    displayProfile = 1, //简介
    displayDynamic = 0, //动态`
} displayTypeOfInfo;

@interface AuthorInfoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,weak) AuthorInfoDetailHeadView *headView;

@property (nonatomic,strong) AuthorInfoModel *model;

@property (nonatomic,strong) NSArray<NSString  *> *shareText;

@property (nonatomic,assign) displayTypeOfInfo displayTypeOfInfo;

@property (nonatomic,strong) FeedsDataModel *feedsDataModel;


@property (nonatomic,strong) AuthorProfileView *profileView;

@property (nonatomic,strong) wordsOptionsHeadView *optionHeadView;

@end

static NSInteger page_num = 0;

@implementation AuthorInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self setupTableViewAndHeadView];
    
    [self requstData];
}

- (void)requstData {
    
    NSString *url = [NSString stringWithFormat:AuthorInfoUrlStringFormat,self.authorID];
    
    weakself(self);
    
    [AuthorInfoModel requestModelDataWithUrlString:url complish:^(id result) {
        
        AuthorInfoModel *md = (AuthorInfoModel *)result;
        
        if (!md) return;
        
        weakSelf.headView.model = md;
        weakSelf.model = md;
        
    } cachingPolicy:ModelDataCachingPolicyDefault hubInView:self.view];
    
    NSString *feedDataUrl = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/feed_lists?catalog_type=3&page_num=1&since=0&uid=%@",self.authorID];
    
    
    [FeedsDataModel requestModelDataWithUrlString:feedDataUrl complish:^(id result) {
        
        FeedsDataModel *md = (FeedsDataModel *)result;
        
        if (!md) {
            return ;
        }
        
        weakSelf.feedsDataModel = md;
        
        if (weakSelf.displayTypeOfInfo == displayDynamic) {
            [weakSelf.tableView reloadData];
        }
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:nil];
    
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
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
    
    tableView.mj_footer = footer;
    
    [tableView registerClass:[AuthorTopicInfoCell class] forCellReuseIdentifier:AuthorTopicInfoCellReuseIdentifier];
    
    [tableView registerClass:[AuthorShareInfoCell class] forCellReuseIdentifier:AuthorShareInfoCellIdentifier];
    
    [tableView registerClass:[StatusCell class] forCellReuseIdentifier:statusCellReuseIdentifier];
    
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

- (void)loadMoreDate {
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/feed_lists?catalog_type=3&page_num=%zd&since=%@&uid=%@",page_num,self.feedsDataModel.since,self.authorID];
    
    weakself(self);
    
    [FeedsDataModel requestModelDataWithUrlString:url complish:^(id result) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        FeedsDataModel *md = (FeedsDataModel *)result;
        
        if (md.feeds.count < 1) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [weakSelf.feedsDataModel.feeds addObjectsFromArray:md.feeds];
         weakSelf.feedsDataModel.since = md.since;
        [weakSelf.tableView fd_reloadDataWithoutInvalidateIndexPathHeightCache];
        page_num++;
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:nil];
    
}


#pragma mark -cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.displayTypeOfInfo == displayDynamic ? 2 : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.displayTypeOfInfo == displayDynamic) {
        return [self.tableView fd_heightForCellWithIdentifier:statusCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            
            StatusCell *cell1 = (StatusCell *)cell;
            
            cell1.model = [self.feedsDataModel.feeds objectAtIndex:indexPath.row];
            
        }];
    }
    
    if (indexPath.section == 2) {
        return AuthorShareInfoCellHeight;
    }else if (indexPath.section == 3) {
        return AuthorTopicInfoCellHeight;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.displayTypeOfInfo == displayDynamic) {
        return [StatusCell configureCellWithModel:self.feedsDataModel inTableView:tableView AtIndexPath:indexPath];
    }
    
    if (indexPath.section == 2) {
        
        AuthorShareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorShareInfoCellIdentifier];
        
        NSInteger index = indexPath.row;
        
        [cell setText:self.shareText[index] atIndex:index];
        
        return cell;
        
    }else if (indexPath.section == 3) {
        
        AuthorTopicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorTopicInfoCellReuseIdentifier];
        
        cell.model = self.model.topics[indexPath.row];
        
        return cell;
        
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 0;
    
    if (self.displayTypeOfInfo == displayDynamic) {
        return self.feedsDataModel.feeds.count;
    }
    
    if (section == 2) {
        return self.shareText.count;
    }else if(section == 3) {
        return self.model.topics.count;
    }
    
    return 0;
}

#pragma mark - tableDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 2) {
        
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
        
    }else if (section == 3) {
        
        topicModel *md = self.model.topics[indexPath.row];

        WordsDetailViewController *wdVc = [[WordsDetailViewController alloc] init];
        
        wdVc.wordsID = md.ID.stringValue;
        
        [self.navigationController pushViewController:wdVc animated:YES];
        
    }
    
}

#pragma mark - sectionHeader

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return wordsOptionsHeadViewHeight;
    
    if (self.displayTypeOfInfo == displayProfile) {
        
        switch (section) {
            case 1:
            {
                return 100;
            }
            case 2:
            {
                return 40;
            }
            case 3:
            {
                return 40;
            }
        }
        
    }
    
    return 0.01f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return self.optionHeadView;
    
    if (self.displayTypeOfInfo == displayDynamic) {
        return [[UIView alloc] initWithFrame:self.view.bounds];
    }
    
    switch (section) {
        case 1:
        {
            if (self.model.intro.length) {
                self.profileView.profileText.text = self.model.intro;
            }
            return self.profileView;
        }
        case 2:
        {
            return [self creatSectionHeadViewWithTitle:@"更多信息"];
        }
        case 3:
        {
            return [self creatSectionHeadViewWithTitle:@"TA的作品"];
        }
    }
    
    return [[UIView alloc] initWithFrame:self.view.bounds];
}

- (UIView *)creatSectionHeadViewWithTitle:(NSString *)title {
    
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:self.view.bounds];
    sectionHeadView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    
    [sectionHeadView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionHeadView).offset(8);
        make.top.bottom.equalTo(sectionHeadView);
    }];
    
    return sectionHeadView;
    
}

#pragma mark - sectionFooter

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:self.view.bounds];
        
    spaceLine.backgroundColor = [UIColor clearColor];
        
    return spaceLine;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || self.displayTypeOfInfo == displayProfile) return 10;
    
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

- (void)setDisplayTypeOfInfo:(displayTypeOfInfo)displayTypeOfInfo {
    _displayTypeOfInfo = displayTypeOfInfo;
    
    self.tableView.mj_footer.hidden = displayTypeOfInfo == displayProfile;
    
    [self.tableView fd_reloadDataWithoutInvalidateIndexPathHeightCache];
}


- (AuthorProfileView *)profileView {
    if (!_profileView) {
        _profileView = [[AuthorProfileView alloc] initWithFrame:self.view.bounds];
    }
    return _profileView;
}

- (wordsOptionsHeadView *)optionHeadView {
    
    if (!_optionHeadView) {
        
        _optionHeadView = [[wordsOptionsHeadView alloc] initWithFrame:self.view.bounds];
        
        [_optionHeadView.leftBtn  setTitle:@"资料" forState:UIControlStateNormal];
        [_optionHeadView.rightBtn setTitle:@"动态" forState:UIControlStateNormal];
        
        weakself(self);

        [_optionHeadView setLefeBtnClick:^(UIButton *btn) {
            weakSelf.displayTypeOfInfo = displayProfile;
        }];
        
        [_optionHeadView setRightBtnClick:^(UIButton *btn) {
            weakSelf.displayTypeOfInfo = displayDynamic;
        }];
        
    }
    
    return _optionHeadView;
}

@end
