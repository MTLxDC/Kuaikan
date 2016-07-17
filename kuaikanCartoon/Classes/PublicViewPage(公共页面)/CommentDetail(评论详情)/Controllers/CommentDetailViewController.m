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

#import <UITableView+FDTemplateLayoutCell.h>
#import <MJRefresh.h>

@interface CommentDetailViewController () <UITableViewDataSource,UITableViewDelegate,CommentSendViewContainerDelegate>

@property (nonatomic,weak)   UITableView *commentsDisplayListView;

@property (nonatomic,weak)   CommentSendViewContainer *sendViewContainer;

@property (nonatomic,strong) CommentDetailModel *modelData;

@property (nonatomic,strong) CommentInfoCell *commentCell;

@property (nonatomic,weak)   UISegmentedControl *sc;

@property (nonatomic,copy)   NSString *requestUrl;

@property (nonatomic,assign) BOOL isNew;

@end

static NSString * newCommentRequestUrlFormat;
static NSString * hotCommentRequestUrlFormat;

@implementation CommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];

    [self setupNavBar];
    
    [self setupCommentDetailView];
    
    [self update];

    [self sendViewContainer];
}

- (void)setDataType:(commentDataType)dataType {
    _dataType  = dataType;
    if (dataType == ComicsCommentDataType) {
        newCommentRequestUrlFormat = newComicsCommentRequestUrlFormat;
        hotCommentRequestUrlFormat = hotComicsCommentRequestUrlFormat;
    }else if(dataType == FeedsCommentDataType){
        newCommentRequestUrlFormat = newFeedsCommentRequestUrlFormat;
        hotCommentRequestUrlFormat = hotFeedsCommentRequestUrlFormat;
    }
}

+ (instancetype)showInVc:(UIViewController *)vc withDataRequstID:(NSNumber *)ID WithDataType:(commentDataType)dataType {
    
    CommentDetailViewController *cdvc  = [[CommentDetailViewController alloc] init];
    
    cdvc.dataRequstID = ID;
    cdvc.dataType = dataType;
    
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
    
    [self.commentsDisplayListView registerNib:[UINib nibWithNibName:@"CommentInfoCell" bundle:nil]                       forCellReuseIdentifier:commentInfoCellName];
    
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
            [weakSelf.commentsDisplayListView fd_reloadDataWithoutInvalidateIndexPathHeightCache];;
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
    
    NSString *requestUrl = [NSString stringWithFormat:requestFormat,self.dataRequstID,since];
    
    return requestUrl;
}

- (void)update {
    [self setDataType:self.dataType];
    [self.commentsDisplayListView.mj_footer resetNoMoreData];
    
    weakself(self);
    
    NSString *requestFormat = self.isNew ? newCommentRequestUrlFormat : hotCommentRequestUrlFormat;
    
    NSString *requestUrl = [NSString stringWithFormat:requestFormat,self.dataRequstID,0];
    
    [CommentDetailModel requestModelDataWithUrlString:requestUrl complish:^(id res) {
        
        CommentDetailViewController *sself = weakSelf;

         sself.modelData = res;
        
        [sself.commentsDisplayListView reloadData];
        [sself.commentsDisplayListView.mj_header endRefreshing];
        [sself.commentsDisplayListView layoutIfNeeded];
        [sself.commentsDisplayListView setContentOffset:CGPointMake(0, -navHeight)];

        if (sself.modelData.since.integerValue != 0) {
            [sself.commentsDisplayListView.mj_footer setHidden:NO];
        }

    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view] ;
    
}

#pragma mark commentsDisplayListView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellName];
    
    cell.commentsModel = self.modelData.comments[indexPath.row];
    
    return cell;
}

#pragma mark commentsDisplayListView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        CommentsModel *md = self.modelData.comments[indexPath.row];
    
        [self.sendViewContainer replyWithUserName:md.user.nickname commentID:md.ID];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    return [tableView fd_heightForCellWithIdentifier:commentInfoCellName cacheByIndexPath:indexPath configuration:^(id cell) {
        
        CommentInfoCell *commentCell = (CommentInfoCell *)cell;
        
        commentCell.commentsModel = self.modelData.comments[indexPath.row];
        
    }];
    
}

- (void)sendMessageSucceeded:(CommentsModel *)commentContent {
    if (self.sc.selectedSegmentIndex == 0)  [self update];
    
}

- (CommentSendViewContainer *)sendViewContainer {
    if (!_sendViewContainer) {
        _sendViewContainer = [CommentSendViewContainer showWithID:self.dataRequstID WithDataType:self.dataType inView:self.view];
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
