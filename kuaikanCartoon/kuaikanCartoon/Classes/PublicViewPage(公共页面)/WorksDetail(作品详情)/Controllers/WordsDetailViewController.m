//
//  WordsDetailViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "WordsDetailViewController.h"
#import "wordsDetailModel.h"
#import "CommonMacro.h"
#import <Masonry.h>
#import "UIView+Extension.h"
#import "wordTableViewCell.h"
#import "CartoonDetailViewController.h"

#import "wordsDetailHeadView.h"
#import "wordsOptionsHeadView.h"
#import "wordsSequenceView.h"

@interface WordsDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) wordsDetailModel *wordsModel;

@property (nonatomic,weak)   UITableView *contentView;

@property (nonatomic,strong) wordsDetailHeadView *head;

@property (nonatomic,assign) BOOL showIntroduction; //显示简介

@property (nonatomic,strong) wordsSequenceView *sequenceView;

@end


@implementation WordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];

    [self setupWordsDetailContentView];
    
    [self updata];
}

- (void)setup {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)setupWordsDetailContentView {
    
   
    UITableView *contenView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    contenView.contentInset = UIEdgeInsetsMake(wordsDetailHeadViewHeight, 0, 0, 0);
    contenView.dataSource = self;
    contenView.delegate = self;
    contenView.rowHeight = 100.0f;
    contenView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    wordsDetailHeadView *head = [wordsDetailHeadView wordsDetailHeadViewWithFrame:CGRectMake(0, 0, self.view.width, wordsDetailHeadViewHeight) scorllView:contenView];
    
    wordsOptionsHeadView *headView = [[wordsOptionsHeadView alloc] init];
    
    [headView setFrame:CGRectMake(0, 0,self.view.width, wordsOptionsHeadViewHeight)];
    
    [headView setLefeBtnClick:^(UIButton *btn) {
        
    }];
    
    [headView setRightBtnClick:^(UIButton *btn) {
        
    }];
    
    contenView.tableHeaderView = headView;
    
    [self.view addSubview:contenView];
    [self.view addSubview:head];

    self.head = head;
    self.contentView = contenView;
}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSortReloadData:(UIButton *)sortBtn {
    [self requestDataWithSortWay:!sortBtn.selected];
}

- (void)updata {
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/topics/%@?sort=0",self.wordsID];
    
    weakself(self);
    
    [wordsDetailModel  requestModelDataWithUrlString:url complish:^(id res) {
        
        if (res == nil) return;
        
        weakSelf.wordsModel = res;
        weakSelf.head.model = res;
        [weakSelf.contentView reloadData];
        
    } cachingPolicy:ModelDataCachingPolicyDefault hubInView:self.view];
    
}

//yes正序,no倒序
- (void)requestDataWithSortWay:(BOOL)sortWay {
    
    self.sequenceView.sortBtn.selected = sortWay;
    self.sequenceView.sortBtn.enabled  = NO;
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/topics/%@?sort=%zd",self.wordsID,sortWay];
    
    weakself(self);
    
    [wordsDetailModel requestModelDataWithUrlString:url complish:^(id res) {
        
        if (res == nil) return;
        
        wordsDetailModel *model = (wordsDetailModel *)res;
        
            weakSelf.wordsModel.comics = model.comics;
            weakSelf.sequenceView.sortBtn.enabled = YES;
            [weakSelf.contentView reloadData];
        
    } cachingPolicy:ModelDataCachingPolicyNoCache hubInView:self.view];
    
}



#pragma mark UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    wordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"wordTableViewCell" owner:nil options:nil] firstObject];
    }
    
    CartonnWordsModel *md = [self.wordsModel.comics objectAtIndex:indexPath.row];
    
    cell.model = md;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordsModel.comics.count;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CartoonDetailViewController *cdv = [[CartoonDetailViewController alloc] init];
    
    CartonnWordsModel *md = self.wordsModel.comics[indexPath.row];
    
    cdv.cartoonId = md.ID.stringValue;
    
    [self.navigationController pushViewController:cdv animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return wordsSequenceViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sequenceView;
}

- (wordsSequenceView *)sequenceView {
    if (!_sequenceView) {
        wordsSequenceView *wsv = [[wordsSequenceView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, wordsSequenceViewHeight)];
        wsv.backgroundColor = [UIColor whiteColor];
        [wsv.sortBtn addTarget:self action:@selector(changeSortReloadData:) forControlEvents:UIControlEventTouchUpInside];
        _sequenceView = wsv;
    }
    return _sequenceView;
}

@end
