//
//  AuthorStatusDetailViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorStatusDetailViewController.h"
#import "CommonMacro.h"

#import <Masonry.h>
#import <UITableView+FDTemplateLayoutCell.h>

#import "StatusCell.h"
#import "CommentInfoCell.h"
#import "CommentDetailModel.h"
#import "FeedsDataModel.h"
#import "CommentSectionHeadView.h"
#import "CommentBottomView.h"

@interface AuthorStatusDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *feedContentView;

@property (nonatomic,strong) CommentDetailModel *model;

@property (nonatomic,weak) CommentBottomView *bottomView;

@end

@implementation AuthorStatusDetailViewController

- (instancetype)initWithFeedsModel:(FeedsModel *)model WithCellHeight:(CGFloat)cellheight
{
    if (self = [super init]) {
        self.feed_Model = model;
        self.statusCellHeight = cellheight;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     super.title = @"动态正文";
    [super setAutomaticallyAdjustsScrollViewInsets:YES];
    
    [super setBackItemWithImage:@"ic_nav_back_normal_11x19_" pressImage:@"ic_nav_back_pressed_11x19_"];
    
    [self setupContentView];

    [self setupCommentBottomView];
    
    [self requstCommentData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.bottomView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)keyboardFrameChange:(NSNotification *)not {
    
    CGFloat end_Y = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat offset = SCREEN_HEIGHT - end_Y;
    
    self.bottomView.beginComment = offset > 0;
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-offset);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)requstCommentData {
    
    NSString *url = [NSString stringWithFormat:newFeedsCommentRequestUrlFormat,self.feed_Model.feed_id,0];
    
    weakself(self);
    
    [CommentDetailModel requestModelDataWithUrlString:url complish:^(id modelData) {
        
        CommentDetailModel *md = (CommentDetailModel *)modelData;
        
        if (!md || !weakSelf) {
            return;
        }
        
         weakSelf.model = md;
        [weakSelf.feedContentView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:nil];
    
}

- (void)setupCommentBottomView {
    
    CommentBottomView *cb = [CommentBottomView commentBottomView];
    
    cb.dataType  = FeedsCommentDataType;
    cb.commentID = self.feed_Model.feed_id;
    cb.recommend_count = self.feed_Model.comments_count.integerValue;
    
    [self.view addSubview:cb];
    
    [cb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(bottomBarHeight));
    }];
    
    self.bottomView = cb;
    
}

- (void)setupContentView {
    
        UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [self.view addSubview:contentView];
        
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.dataSource = self;
        contentView.delegate = self;
        contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        [contentView registerClass:[StatusCell class] forCellReuseIdentifier:statusCellReuseIdentifier];
        [contentView registerClass:[CommentInfoCell class] forCellReuseIdentifier:commentInfoCellName];
        
        [contentView registerNib:[UINib nibWithNibName:@"CommentInfoCell" bundle:nil]  forCellReuseIdentifier:commentInfoCellName];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        self.feedContentView = contentView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.bottomView resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.model.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:statusCellReuseIdentifier];
        
        cell.model = self.feed_Model;
        
        return cell;
        
    }else {
        
        CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellName];
        
        cell.commentsModel = [self.model.comments objectAtIndex:indexPath.row];
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.statusCellHeight;
    }else {
        return [self.feedContentView fd_heightForCellWithIdentifier:commentInfoCellName cacheByIndexPath:indexPath configuration:^(id cell) {
            
            FeedsModel *model = [self.model.comments objectAtIndex:indexPath.row];
            
            [cell performSelector:@selector(setCommentsModel:) withObject:model];
        
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   if (section == 0) return 8;

    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *line = [[UIView alloc] initWithFrame:self.view.bounds];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return line;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) return CommentSectionHeadViewHeight;
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        CommentSectionHeadView *cshv = [[CommentSectionHeadView alloc] initWithFrame:self.view.bounds];
        cshv.text = @"最新评论";
        
        return cshv;
    }
    
    return [[UIView alloc] initWithFrame:self.view.bounds];
}


@end
