//
//  MyMessageViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageCell.h"
#import "ReplyDataModel.h"
#import "CommentSendViewContainer.h"
#import "CommentDetailViewController.h"

#import <UITableView+FDTemplateLayoutCell.h>

@interface MyMessageViewController () <CommentSendViewContainerDelegate>

@property (nonatomic,strong) ReplyDataModel *model;

@property (nonatomic,weak)   CommentSendViewContainer *csvc;

@property (nonatomic,strong) ReplyCommentsModel *replyModel;

@end


@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    self.tableView.estimatedRowHeight = SCREEN_HEIGHT * 0.2;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyMessageCell" bundle:nil] forCellReuseIdentifier:MyMessageCellIdentifier];
    
    self.csvc = [CommentSendViewContainer showInView:self.view];
    self.csvc.delegate = self;
    
    [self updata];
    
    
}

- (void)updata {

    NSString *url = @"http://api.kuaikanmanhua.com/v1/comments/replies/timeline?since=0";
    
    weakself(self);
    
    [ReplyDataModel requestModelDataWithUrlString:url complish:^(id result) {
        
         weakSelf.model = result;
         weakSelf.tableView.mj_footer.hidden = weakSelf.model.since.integerValue == 0;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyReload hubInView:self.view];
        
}

- (void)loadMoreData {
    
    if (self.model.since.integerValue == 0) return;
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comments/replies/timeline?since=%@",self.model.since];
    
    weakself(self);
    
    [ReplyDataModel requestModelDataWithUrlString:url complish:^(id result) {
        
        ReplyDataModel *resultModel = (ReplyDataModel *)result;
        
        [weakSelf.model.comments addObjectsFromArray:resultModel.comments];
         weakSelf.model.since = resultModel.since;
        [weakSelf.tableView fd_reloadDataWithoutInvalidateIndexPathHeightCache];
        
        if (resultModel.comments.count < 1 || resultModel.since.integerValue == 0) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MyMessageCellIdentifier];

    cell.model = [self.model.comments objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.tableView fd_heightForCellWithIdentifier:MyMessageCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        
        MyMessageCell *cell1 = (MyMessageCell *)cell;
        
        cell1.model = [self.model.comments objectAtIndex:indexPath.row];
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReplyCommentsModel *model = self.model.comments[indexPath.row];
    
    self.csvc.dataRequstID = model.target_comic.ID;
    
    [self.csvc replyWithUserName:model.user.nickname commentID:model.ID];
    
    self.replyModel = model;
}

- (void)sendMessageSucceeded:(CommentsModel *)commentContent {
    [CommentDetailViewController showInVc:self
                         withDataRequstID:self.replyModel.ID
                             WithDataType:ComicsCommentDataType];
}


@end
