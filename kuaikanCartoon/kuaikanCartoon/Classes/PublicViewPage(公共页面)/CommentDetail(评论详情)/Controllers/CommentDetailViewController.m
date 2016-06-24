//
//  CommentDetailViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "UIBarButtonItem+EXtension.h"
#import "CommentsModel.h"
#import <Masonry.h>
#import "CommonMacro.h"
#import "CommentSendView.h"
#import "UserInfoManager.h"

#import "CommentInfoCell.h"
#import "CommentDetailModel.h"
#import "CommentSendViewContainer.h"

#import <MJRefresh.h>

@interface CommentDetailViewController () <UITableViewDataSource,UITableViewDelegate,CommentSendViewContainerDelegate>

@property (nonatomic,weak)   UITableView *commentsDisplayListView;

@property (nonatomic,weak)   CommentSendViewContainer *sendViewContainer;

@property (nonatomic,strong) CommentDetailModel *modelData;

@property (nonatomic,strong) CommentInfoCell *commentCell;

@property (nonatomic,weak)   UISegmentedControl *sc;

@property (nonatomic,strong) NSMutableArray *cellHeightCache;

@property (nonatomic,copy)   NSString *requestUrl;

@property (nonatomic,assign) BOOL isNew;

@end


static NSString * const hotCommentRequestUrlFormat =
@"http://api.kuaikanmanhua.com/v1/comics/%@/comments/%zd?order=score";

static NSString * const newCommentRequestUrlFormat =
@"http://api.kuaikanmanhua.com/v1/comics/%@/comments/%zd?";


@implementation CommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];

    [self setupNavBar];
    
    [self setupCommentDetailView];
    
    [self update];

    [self sendViewContainer];
}


+ (instancetype)showInVc:(UIViewController *)vc withComicID:(NSNumber *)ID {
    
    CommentDetailViewController *cdvc  = [[CommentDetailViewController alloc] init];
    
    cdvc.comicID = ID;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cdvc];
    
    [vc presentViewController:nav animated:YES completion:^{
        
    }];
    
    return cdvc;
}

#pragma mark setupSubViews

- (void)setupNavBar {
    
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:@[@"最新评论",@"最热评论"]];
    
    [sc setTintColor:[UIColor lightGrayColor]];
    
    NSDictionary *normalTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSDictionary *selectTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [sc setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
    
    [sc setTitleTextAttributes:selectTextAttributes forState:UIControlStateSelected];
    
    [sc addTarget:self action:@selector(selectedSegmentIndex:) forControlEvents:UIControlEventValueChanged];

    
    self.navigationItem.titleView = sc;
    
    [sc setSelectedSegmentIndex:0];
    
   self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"ic_nav_delete_normal_17x17_" pressImage:@"ic_nav_delete_pressed_17x17_" target:self action:@selector(dismiss)];

    self.sc = sc;
}

- (void)setupCommentDetailView {
    
    UITableView *commentsDisplayListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:commentsDisplayListView];
    
    [commentsDisplayListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-bottomBarHeight);
    }];
    
    self.commentsDisplayListView = commentsDisplayListView;
    
    self.commentsDisplayListView.dataSource = self;
    self.commentsDisplayListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentsDisplayListView.delegate = self;
    self.commentsDisplayListView.estimatedRowHeight = 100;
    
    self.cellHeightCache = [NSMutableArray array];
    
    
    weakself(self);
    
    //上拉刷新
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(update)
    ];
    
    [refreshHeader.arrowView setImage:[UIImage imageNamed:@"ic_pull_refresh_arrow_22x22_"]];
    
    self.commentsDisplayListView.mj_header = refreshHeader;
    
    //下拉加载更多
    self.commentsDisplayListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [CommentDetailModel requestModelDataWithUrlString:self.requestUrl complish:^(id res) {
            
            CommentDetailModel *md = (CommentDetailModel *)res;
            
            if (md.comments.count < 1) {
                [weakSelf.commentsDisplayListView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
            [weakSelf.modelData.comments addObjectsFromArray:md.comments];
             weakSelf.modelData.since = md.since;
            [weakSelf.commentsDisplayListView reloadData];
            [weakSelf.commentsDisplayListView.mj_footer endRefreshing];

            
        } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view];
        
        
    }];
    
    [self.commentsDisplayListView.mj_footer setHidden:YES];
}

- (BOOL)isNew {
    return self.sc.selectedSegmentIndex == 0;
}

- (NSString *)requestUrl {
    
    NSString *requestFormat = self.isNew ? newCommentRequestUrlFormat : hotCommentRequestUrlFormat;
    
    NSInteger since = 0;
    
    if (self.modelData.comments.count > 0) {
        since = self.modelData.since.integerValue;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:requestFormat,self.comicID.stringValue,since];
    
    return requestUrl;
}

- (void)update {
    
    [self.commentsDisplayListView.mj_footer resetNoMoreData];
    
    weakself(self);
    
    
    NSString *requestFormat = self.isNew ? newCommentRequestUrlFormat : hotCommentRequestUrlFormat;
    
    NSString *requestUrl = [NSString stringWithFormat:requestFormat,self.comicID.stringValue,0];
    
    [CommentDetailModel requestModelDataWithUrlString:requestUrl complish:^(id res) {
        
        CommentDetailViewController *sself = weakSelf;

         sself.modelData = res;
        [sself.cellHeightCache removeAllObjects];
        [sself.commentsDisplayListView reloadData];
        [sself.commentsDisplayListView.mj_header endRefreshing];
        [sself.commentsDisplayListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                             atScrollPosition:UITableViewScrollPositionNone animated:NO];

        if (sself.modelData.since.integerValue != 0) {
            [sself.commentsDisplayListView.mj_footer setHidden:NO];
        }

    } cachingPolicy:ModelDataCachingPolicyDefault hubInView:self.view] ;
    
}

#pragma mark commentsDisplayListView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellName];
    
    if (!cell) {
        cell = [CommentInfoCell makeCommentInfoCell];
    }
    
    cell.commentsModel = self.modelData.comments[indexPath.row];
    
    return cell;
}



#pragma mark commentsDisplayListView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        CommentsModel *md = self.modelData.comments[indexPath.row];
    
        [self.sendViewContainer replyWithUserName:md.user.nickname commentID:md.ID];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (iOS8Later) return UITableViewAutomaticDimension;

    if (self.cellHeightCache.count > indexPath.row) {
        
        NSNumber *cacheHeight = self.cellHeightCache[indexPath.row];
        
        if (cacheHeight) return cacheHeight.doubleValue;
        
    }
    
    //实例一个Cell专门用来算高,如果是多个Cell,用字典,重用标识符做key,cell做value;
    
    CommentInfoCell *cell = self.commentCell;
    
    cell.commentsModel = self.modelData.comments[indexPath.row];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f,
                             CGRectGetWidth(tableView.bounds),
                             CGRectGetHeight(cell.bounds));
    
    // 得到cell的contentView需要的真实高度
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // 要为cell的分割线加上额外的1pt高度。因为分隔线是被加在cell底边和contentView底边之间的。
    height += 1.0f;
    
    [self.cellHeightCache addObject:@(height)];
    
    return height;
    
}

- (void)sendMessageSucceeded:(CommentsModel *)commentContent {
    if (self.sc.selectedSegmentIndex == 0)  [self update];
    
}

- (CommentInfoCell *)commentCell {
    if (!_commentCell) {
        _commentCell = [CommentInfoCell makeCommentInfoCell];
    }
    return _commentCell;
}

- (CommentSendViewContainer *)sendViewContainer {
    if (!_sendViewContainer) {
        _sendViewContainer = [CommentSendViewContainer showWithComicID:self.comicID inView:self.view];
        _sendViewContainer.delegate = self;
    }
    return _sendViewContainer;
}

- (void)selectedSegmentIndex:(UISegmentedControl *)sc
{
    [self update];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
