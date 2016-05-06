//
//  CartoonDetailViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CartoonDetailViewController.h"
#import "Color.h"
#import "CommentBottomView.h"
#import <Masonry.h>
#import "comicsModel.h"
#import "CommonMacro.h"

#import <UIImageView+WebCache.h>
#import "CartoonFlooterView.h"
#import "CartoonContentCell.h"
#import "authorInfoHeadView.h"

@interface CartoonDetailViewController () <UITableViewDataSource,UITableViewDelegate,CartoonFlooterViewDelegate>

@property (nonatomic,strong) comicsModel *comicsMd;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,weak) UITableView *cartoonContentView;

@property (nonatomic,weak) CommentBottomView *bottomView;

@property (nonatomic,strong) MASConstraint *bottomConstraint;

@end


static const CGFloat imageCellHeight = 250.0f;

@implementation CartoonDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupCartoonContentView];
    
    [self requestData];
    
    [self setupNavigationBar];
    
    [self setupTitleView];
    
    [self setupCommentBottomView];
    
    
}

- (void)requestData {
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comics/%@?",self.cartoonId];
    
    weakself(self);
    
    [comicsModel requestComicsDetailModelDataWithUrlString:url complish:^(id res) {
        if ([res isKindOfClass:[NSError class]] || res == nil || weakSelf == nil) {
            DEBUG_Log(@"%@",res);
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.comicsMd = res;
            [weakSelf updataUI];
        });
        
    } useCache:YES];
    
}

- (void)updataUI {
    
    self.titleLabel.text = self.comicsMd.title;
    self.bottomView.recommend_count = self.comicsMd.recommend_count.integerValue;
    [self.cartoonContentView reloadData];
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}


- (void)keyboardFrameChange:(NSNotification *)not {
    
    CGFloat kb_Y = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat offset = kb_Y - SCREEN_HEIGHT;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.bottomConstraint.offset(-offset);
    }];
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:15.0f options:UIViewAnimationOptionTransitionNone animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        
    }];
}


- (void)gotoCollectedWorksPage {
    printf("%s\n",__func__);
}

- (void)setupNavigationBar {
    
    
    UIBarButtonItem *collectedWorks = [[UIBarButtonItem alloc] initWithTitle:@"全集" style:UIBarButtonItemStylePlain target:self action:@selector(gotoCollectedWorksPage)];
    
    self.navigationItem.rightBarButtonItem = collectedWorks;
    
    [collectedWorks setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:subjectColor}forState:UIControlStateNormal];
    
    [super setBackItemWithImage:@"ic_nav_back_normal_11x19_" pressImage:@"ic_nav_back_pressed_11x19_"];
    [self.navigationController.navigationBar setBarTintColor:White(0.95)];
    
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




- (void)setupCommentBottomView {
    
    CommentBottomView *cb = [CommentBottomView commentBottomView];
    
    [self.view addSubview:cb];
    
    [cb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        self.bottomConstraint = make.bottom.equalTo(self.view).offset(0);
        make.height.equalTo(@44);
    }];
    
    self.bottomView = cb;
    
}

static NSString * const authorInfoHeadViewIdentifier = @"authorInfoHeadView";
static NSString * const CartoonFlooterViewIdentifier = @"CartoonFlooterView";
static NSString * const CartoonContentCellIdentifier = @"CartoonContentCell";


- (void)setupCartoonContentView {
    
    UITableView *contentView = [UITableView new];
    [self.view addSubview:contentView];
    
    contentView.dataSource = self;
    contentView.delegate = self;
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [contentView registerClass:[authorInfoHeadView class] forCellReuseIdentifier:authorInfoHeadViewIdentifier];
    
    [contentView registerNib:[UINib nibWithNibName:@"CartoonFlooterView" bundle:nil] forCellReuseIdentifier:CartoonFlooterViewIdentifier];
    
    [contentView registerClass:[CartoonContentCell class] forCellReuseIdentifier:CartoonContentCellIdentifier];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHeight);
        make.bottom.equalTo(self.view).offset(-bottomBarHeight);
    }];
    
    self.cartoonContentView = contentView;
    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.comicsMd) {
        return self.comicsMd.images.count + 2;
    }else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        authorInfoHeadView *head = [tableView dequeueReusableCellWithIdentifier:authorInfoHeadViewIdentifier];
        
        head.user = self.comicsMd.topic.user;
        
        return head;
        
    }else if (indexPath.row == self.comicsMd.images.count + 1) {
        
        CartoonFlooterView *flooter = [tableView dequeueReusableCellWithIdentifier:CartoonFlooterViewIdentifier];
        
        flooter.delegate = self;
        flooter.upCount = self.comicsMd.likes_count.integerValue;
        
        return flooter;
    }
    
    CartoonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CartoonContentCellIdentifier];
    
    NSURL *imageUrl = [NSURL URLWithString:self.comicsMd.images[indexPath.row - 1]];
    
    [cell.content sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"]];
    
    
    return cell;
    
}

//- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//}
//- ( NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    
//}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == self.comicsMd.images.count + 2)
    {
        return 200;
    }
    
    return imageCellHeight;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

@end
