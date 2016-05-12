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
#import "wordsDetailHeadView.h"
#import <Masonry.h>
#import "UIView+Extension.h"


@interface WordsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,wordsDetailHeadViewDelegate>

@property (nonatomic,strong) wordsDetailModel *wordsModel;

@property (nonatomic,weak) UITableView *contentView;


@property (nonatomic,strong) wordsDetailHeadView *head;

@end


@implementation WordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];

    [self setupWordsDetailContentView];
    
    [self requestData];
}

- (void)setup {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)setupWordsDetailContentView {
    
   
    UITableView *contenView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    wordsDetailHeadView *head = [wordsDetailHeadView wordsDetailHeadViewWithFrame:CGRectMake(0, 0, self.view.width, headViewHeight) scorllView:contenView];
    
    head.delegate = self;
    
    contenView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
    contenView.dataSource = self;
    contenView.delegate = self;


    [self.view addSubview:contenView];
    [self.view addSubview:head];

    self.head = head;
    
    self.contentView = contenView;
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)follow {
    printf("%s\n",__func__);
}

- (void)requestData {
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/topics/%@?sort=0",self.wordsID];
    
    weakself(self);
    
    [wordsDetailModel requestModelDataWithUrlString:url complish:^(id res) {
        
            weakSelf.wordsModel = res;
        
    } cachingPolicy:ModelDataCachingPolicyDefault];
    
}

- (void)setWordsModel:(wordsDetailModel *)wordsModel {
    _wordsModel = wordsModel;
    
    self.head.model = wordsModel;
    
}



#pragma mark UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"mycell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = @"1111111";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




@end
