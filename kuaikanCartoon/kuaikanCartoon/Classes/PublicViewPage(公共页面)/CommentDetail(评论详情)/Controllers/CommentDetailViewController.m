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
#import <MJRefresh.h>

@interface CommentDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)   UITableView *commentsDisplayListView;

@property (nonatomic,weak)   CommentSendView *sendView;

@property (nonatomic,weak) UIView *sendViewContainer;

@property (nonatomic,strong) CommentDetailModel *modelData;

@property (nonatomic,strong) CommentInfoCell *commentCell;

@property (nonatomic,weak)   UISegmentedControl *sc;

@property (nonatomic,strong) NSMutableArray *cellHeightCache;

@property (nonatomic,copy)   NSString *requestUrl;

@property (nonatomic,assign) BOOL isreply;

@property (nonatomic,strong) CommentsModel *replyComment;

@property (nonatomic,assign) NSInteger since;


@end

@implementation CommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
    
    [self setupCommentDetailView];
    
    [self setupCommentSendView];
    
    [self setRequestUrlWithIsNew:YES withRequestUrl:self.requestID];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.sendView resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
    
- (void)keyboardFrameChange:(NSNotification *)not {
    
    CGFloat end_Y = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat offset = SCREEN_HEIGHT - end_Y;
    
    [self.sendView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-offset);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.sendViewContainer.alpha  = offset == 0 ? 0 : 0.6;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        self.sendViewContainer.hidden = offset == 0;
    }];
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
    
    [super setBackItemWithImage:@"ic_nav_delete_normal_17x17_" pressImage:@"ic_nav_delete_pressed_17x17_"];

    self.sc = sc;
}

- (void)sendViewContinerDidTap {
    [self.sendView resignFirstResponder];
}

- (void)setupCommentSendView {
    
    UIView *sendViewContiner = [[UIView alloc] init];
    [self.view addSubview:sendViewContiner];
    
    sendViewContiner.hidden = YES;
    sendViewContiner.backgroundColor = [UIColor blackColor];
    sendViewContiner.alpha = 0;
    
    [sendViewContiner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [sendViewContiner addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendViewContinerDidTap)]];
    
    self.sendViewContainer = sendViewContiner;
    
    CommentSendView *csv = [CommentSendView makeCommentSendView];
    [self.view addSubview:csv];
    
    self.sendView = csv;
    
    [csv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(bottomBarHeight));
    }];
    
    weakself(self);

    [csv setSendMessage:^(NSString *message) {
        [weakSelf userCommentWithMessage:message];
    }];
    
    
}

- (void)userCommentWithMessage:(NSString *)message {
    
    NSString *requestID = self.isreply ? self.replyComment.ID.stringValue : self.requestID;
    
    weakself(self);
    
    [UserInfoManager sendMessage:message isReply:self.isreply withID:requestID withSucceededCallback:^(CommentsModel *resultModel) {
        
        [[weakSelf sendView] clearText];
        if (weakSelf.sc.selectedSegmentIndex == 0) {
            [weakSelf update];
        }

    }];
    
    self.isreply = NO;
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
    
    self.cellHeightCache = [NSMutableArray array];
    
    
    weakself(self);
    
    //上拉刷新
    
    
    self.commentsDisplayListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(update)
    ];
    
    //下拉加载更多
    self.since = 0;
    
    self.commentsDisplayListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.since += 20;

        NSString *moreCommentUrl = [self.requestUrl stringByReplacingOccurrencesOfString:@"0" withString:[NSString stringWithFormat:@"%zd",self.since]];
        
        [CommentDetailModel requestModelDataWithUrlString:moreCommentUrl complish:^(id res) {
            
            CommentDetailModel *md = (CommentDetailModel *)res;
            
            if (md.comments.count < 1) {
                [weakSelf.commentsDisplayListView.mj_footer endRefreshingWithNoMoreData];
                return ;
            };
            
            [weakSelf.modelData.comments addObjectsFromArray:md.comments];
             weakSelf.modelData.since = md.since;
            [weakSelf.commentsDisplayListView reloadData];
            [weakSelf.commentsDisplayListView.mj_footer endRefreshing];
            
        } cachingPolicy:ModelDataCachingPolicyNoCache];
        
        
    }];
}

- (void)setRequestUrlWithIsNew:(BOOL)isNew withRequestUrl:(NSString *)requestID {
    
    NSString *requestFormat = isNew ? newCommentRequestUrlFormat : hotCommentRequestUrlFormat;
    
    NSString *requestUrl = [NSString stringWithFormat:requestFormat,requestID];
    
    self.requestUrl = requestUrl;
    
    [self update];
}


- (void)update {
    
    weakself(self);
    
    [CommentDetailModel requestModelDataWithUrlString:self.requestUrl complish:^(id res) {
        
        CommentDetailViewController *sself = weakSelf;
        
         sself.modelData = res;
        [sself.cellHeightCache removeAllObjects];
        [sself.commentsDisplayListView reloadData];
        [sself.commentsDisplayListView setContentOffset:CGPointMake(0, -navHeight)];
        [sself.commentsDisplayListView.mj_header endRefreshing];

    } cachingPolicy:ModelDataCachingPolicyNoCache] ;
    
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
    
        self.isreply = YES;
        self.replyComment = md;
    
    NSString *userName = md.user.nickname;
    
    NSString *placeText = [NSString stringWithFormat:@"回复@%@",userName];

        [self.sendView becomeFirstResponder];
        [self.sendView setPlaceText:placeText];
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

- (CommentInfoCell *)commentCell {
    if (!_commentCell) {
        _commentCell = [CommentInfoCell makeCommentInfoCell];
    }
    return _commentCell;
}


- (void)selectedSegmentIndex:(UISegmentedControl *)sc
{
    [self setRequestUrlWithIsNew:!sc.selectedSegmentIndex withRequestUrl:self.requestID];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
