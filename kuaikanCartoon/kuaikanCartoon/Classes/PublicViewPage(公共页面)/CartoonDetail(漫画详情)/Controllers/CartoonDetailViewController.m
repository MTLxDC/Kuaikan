//
//  CartoonDetailViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CartoonDetailViewController.h"
#import "CommentDetailViewController.h"
#import "WordsDetailViewController.h"

#import "Color.h"
#import "NetWorkManager.h"
#import "ProgressHUD.h"
#import "UserInfoManager.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "comicsModel.h"
#import "CommentsModel.h"
#import "CommonMacro.h"

#import "CommentSectionHeadView.h"
#import "FindHeaderSectionView.h"
#import "CartoonFlooterView.h"
#import "CartoonContentCell.h"
#import "authorInfoHeadView.h"
#import "CommentBottomView.h"
#import "CommentInfoCell.h"
#import "UIView+Extension.h"


@interface CartoonDetailViewController () <UITableViewDataSource,UITableViewDelegate,CartoonFlooterViewDelegate,CommentBottomViewDelegate>

@property (nonatomic,strong) comicsModel *comicsMd;

@property (nonatomic,weak)   UILabel *titleLabel;

@property (nonatomic,weak)   UITableView *cartoonContentView;

@property (nonatomic,weak)   CommentBottomView *bottomView;

@property (nonatomic,weak)   UISlider *progress;

@property (nonatomic,strong) NSMutableArray *commentCellHeightCache;

@property (nonatomic,strong) CommentInfoCell *commentCell;  //计算CellHeight用

@property (nonatomic,strong) NSArray *commentModels;

@property (nonatomic,strong) CartoonFlooterView *flooter;

@end


static const CGFloat imageCellHeight = 250.0f;

@implementation CartoonDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupCartoonContentView];
    
    [self setupNavigationBar];
    
    [self setupTitleView];
    
    [self setupCommentBottomView];
    
    [self requestData];
    
    [self setupProgress];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
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
    
    [self hideOrShowProgressView:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)requestData {
    
   NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comics/%@?",self.cartoonId];
    
    weakself(self);
    
    self.view.hidden = YES;
    
   [comicsModel requestModelDataWithUrlString:url complish:^(id res) {
              
       CartoonDetailViewController *sself = weakSelf;
       
            sself.comicsMd = res;
            [sself updataUI];
            if (res == nil)   sself.view.hidden = NO;
       
       
   } cachingPolicy:ModelDataCachingPolicyDefault hubInView:self.view];
    
    
    NSString *commentUrl = [NSString stringWithFormat:hotCommentRequestUrlFormat,self.cartoonId];
    
    [CommentsModel requestModelDataWithUrlString:commentUrl complish:^(id result) {
        
        CartoonDetailViewController *sself = weakSelf;
        sself.commentModels = result;
        
        [sself.cartoonContentView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                
    } cachingPolicy:ModelDataCachingPolicyDefault hubInView:self.view];
    
}

- (void)updataUI {
    
    self.titleLabel.text = self.comicsMd.title;
    self.bottomView.recommend_count = self.comicsMd.comments_count.integerValue;
    [self.cartoonContentView reloadData];
    [self.cartoonContentView setContentOffset:CGPointMake(0, -navHeight)];
}

static CGFloat progressWidth = 150;

- (void)hideOrShowHeadBottomView:(BOOL)needhide
{
    
    [self.view endEditing:needhide];
    
    [self.navigationController setNavigationBarHidden:needhide animated:YES];
    
    CGFloat offset = needhide ? bottomBarHeight : 0;
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {    //隐藏底部视图
        make.bottom.equalTo(self.view).offset(offset);
    }];

    [UIView animateWithDuration:0.25 animations:^{
        [self.bottomView layoutIfNeeded];
    }];
    
}


- (void)hideOrShowProgressView:(BOOL)needhide {
    
    if (self.progress.hidden == needhide) return;
    
    if (needhide == NO) self.progress.hidden = needhide;
    
    CGFloat p_w = needhide ? 0 : progressWidth;
    
    [self.progress mas_updateConstraints:^(MASConstraintMaker *make) {      //隐藏进度条
        make.width.equalTo(@(p_w));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.progress layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
      if (needhide == YES) self.progress.hidden = needhide;
        
    }] ;
    
}

static bool needHide = false;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.bottomView.beginComment) {
        needHide = !needHide;
        [self hideOrShowHeadBottomView:needHide];
        [self hideOrShowProgressView:needHide];
    }else {
        [self.bottomView resignFirstResponder];
        [self hideOrShowProgressView:NO];
    }
}

- (BOOL)prefersStatusBarHidden {
    return needHide;
}

- (void)setupNavigationBar {
    
    UIBarButtonItem *collectedWorks = [[UIBarButtonItem alloc] initWithTitle:@"全集" style:UIBarButtonItemStylePlain target:self action:@selector(gotoCollectedWorksPage)];
    
    self.navigationItem.rightBarButtonItem = collectedWorks;
    
    [collectedWorks setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:subjectColor}forState:UIControlStateNormal];
    
    [super setBackItemWithImage:@"ic_nav_back_normal_11x19_" pressImage:@"ic_nav_back_pressed_11x19_"];    
}

- (void)setupTitleView {
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.66, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:textView.frame];
    
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
    [textView addSubview:label];
    
    self.titleLabel = label;
    
    self.navigationItem.titleView = textView;
    
}

#pragma mark CommentBottomView

CGFloat contentSizeMaxHeight = 100.0f;

- (void)setupCommentBottomView {
    
    CommentBottomView *cb = [CommentBottomView commentBottomView];
    
    cb.delegate = self;
    
    [self.view addSubview:cb];
    
    [cb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(bottomBarHeight));
    }];
    
    self.bottomView = cb;


}

- (void)sendMessage:(NSString *)message {
    weakself(self);
    
    [UserInfoManager sendMessage:message isReply:NO withID:self.cartoonId withSucceededCallback:^(CommentsModel *md) {
        [weakSelf.bottomView sendSucceeded];
    }];
}


- (void)textView:(UITextView *)textView ContenSizeDidChange:(CGSize)size {
    
    CGFloat offset_H = size.height;
    
    textView.showsVerticalScrollIndicator = offset_H > contentSizeMaxHeight;

    if (offset_H > contentSizeMaxHeight) return;
    
    if (offset_H < bottomBarHeight) {
        offset_H = bottomBarHeight;
    }
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(offset_H));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.bottomView layoutIfNeeded];
    }];
}

- (void)showCommentPage {
    
    CommentDetailViewController  *cdVc = [[CommentDetailViewController alloc] init];
    
    cdVc.requestID = self.comicsMd.ID.stringValue;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cdVc];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


- (void)gotoCollectedWorksPage {
    
    WordsDetailViewController *wdc = [[WordsDetailViewController alloc] init];
    
    wdc.wordsID = self.comicsMd.topic.ID.stringValue;
    
    [self.navigationController pushViewController:wdc animated:YES];
}


#pragma mark 设置滑动条

- (void)setupProgress{
    
    
    //进度滑动条
    UISlider *progress = [[UISlider alloc] init];
    
    [self.view addSubview:progress];
    
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.centerY.equalTo(self.view);
        make.width.equalTo(@(progressWidth));
        make.centerX.equalTo(self.view.mas_right).offset(-20);
    }];
    
    //设置滑动条
    
    progress.minimumValue = 0;
    progress.maximumValue = 1;
    progress.value = 0;
    progress.continuous = NO;
    
    [progress setMaximumTrackImage:[UIImage imageNamed:@"progress_right"] forState:UIControlStateNormal];
    [progress setMinimumTrackImage:[UIImage imageNamed:@"progress_left"] forState:UIControlStateNormal];
    [progress setThumbImage:[UIImage imageNamed:@"progress_point"] forState:UIControlStateNormal];
    [progress setThumbImage:[UIImage imageNamed:@"progress_point"] forState:UIControlStateHighlighted];
    
    [progress addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventValueChanged];

    progress.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    self.progress = progress;
}

- (void)sliderDragUp:(UISlider *)progress {
    
    CGFloat y = (self.cartoonContentView.contentSize.height -
                 self.cartoonContentView.height) * progress.value;
    
    [self.cartoonContentView setContentOffset:CGPointMake(0, y)];
}



#pragma mark 设置tableview

static NSString * const CartoonFlooterViewIdentifier = @"CartoonFlooterView";
static NSString * const CartoonContentCellIdentifier = @"CartoonContentCell";

- (void)setupCartoonContentView {
    
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:contentView];
    
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.dataSource = self;
    contentView.delegate = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [contentView registerClass:[CartoonContentCell class] forCellReuseIdentifier:CartoonContentCellIdentifier];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    
    self.cartoonContentView = contentView;
    
}


#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return authorInfoHeadViewHeight;
    if (section == 1) return CommentSectionHeadViewHeight;

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        authorInfoHeadView *head = [[authorInfoHeadView alloc] initWithFrame:self.view.bounds];
        
        head.model = self.comicsMd;
        
        return head;
    }
    
    if (section == 1) {
        return [[CommentSectionHeadView alloc] initWithFrame:self.view.bounds];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) return CartoonFlooterViewHeight;

    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        self.flooter.model = self.comicsMd;
        
        return self.flooter;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.comicsMd.images.count;
    }else if (section == 1) {
        return self.commentModels.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CartoonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CartoonContentCellIdentifier];
        
        NSURL *imageUrl = [NSURL URLWithString:self.comicsMd.images[indexPath.row]];
        
        [cell.content sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"]];
        
        
        return cell;

    }
    
    if (indexPath.section == 1)
    {
        CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellName];
        if (!cell) {
            cell = [CommentInfoCell makeCommentInfoCell];
        }
        
        cell.commentsModel = self.commentModels[indexPath.row];
        
        return cell;
    }
    
    return nil;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return imageCellHeight;
        
    }else if (indexPath.section == 1) {
        
        
        if (self.commentCellHeightCache.count > indexPath.row) {
            
            NSNumber *cacheHeight = self.commentCellHeightCache[indexPath.row];
            
            if (cacheHeight) return cacheHeight.doubleValue;
            
        }
        
        //实例一个Cell专门用来算高,如果是多个Cell,用字典,重用标识符做key,cell做value;
        
        CommentInfoCell *cell = self.commentCell;
        
        //将数据传给cell
        cell.commentsModel = self.commentModels[indexPath.row];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        [cell setNeedsLayout];          //强制更新cell的布局
        [cell layoutIfNeeded];
        
        cell.bounds = CGRectMake(0.0f, 0.0f,
                                 CGRectGetWidth(tableView.bounds),
                                 CGRectGetHeight(cell.bounds));
        
        // 得到cell的contentView需要的真实高度
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        // 要为cell的分割线加上额外的1pt高度。因为分隔线是被加在cell底边和contentView底边之间的。
        height += 1.0f;
        
        [self.commentCellHeightCache addObject:@(height)];
        
        return height;

    }

    return 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideOrShowHeadBottomView:YES];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)sc {
    
    CGFloat offsetY = sc.contentOffset.y;
    CGFloat maxOffsetY = sc.contentSize.height - sc.height;
    
    self.progress.value = offsetY/maxOffsetY;
    
}


#pragma mark CartoonFlooterViewDelegate

- (void)commentButtonAction {
    [self showCommentPage];
}                       //开启评论

- (void)previousPage {
    self.cartoonId = self.comicsMd.previous_comic_id.stringValue;
    [self requestData];
}                       //上一篇

- (void)nextPage {
    
    self.cartoonId = self.comicsMd.next_comic_id.stringValue;
    [self requestData];
}                       //下一篇

- (void)showShareView {
    
}                       //显示分享视图

#pragma mark Lazy load

- (NSMutableArray *)commentCellHeightCache {
    if (!_commentCellHeightCache) {
        _commentCellHeightCache = [[NSMutableArray alloc] init];
    }
    return _commentCellHeightCache;
}

- (CommentInfoCell *)commentCell {
    if (!_commentCell) {
        _commentCell = [CommentInfoCell makeCommentInfoCell];
    }
    return _commentCell;
}

- (CartoonFlooterView *)flooter {
    if (!_flooter) {
        _flooter = [CartoonFlooterView makeCartoonFlooterView];
        _flooter.delegate = self;
    }
    return _flooter;
}


@end
