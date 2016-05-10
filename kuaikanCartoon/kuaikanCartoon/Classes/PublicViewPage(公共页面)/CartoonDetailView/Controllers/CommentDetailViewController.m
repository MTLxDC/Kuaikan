//
//  CommentDetailViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "UIBarButtonItem+EXtension.h"
#import "CommentDetailView.h"
#import "CommentsModel.h"
#import <Masonry.h>
#import "CommonMacro.h"

@interface CommentDetailViewController ()

@property (nonatomic,weak) CommentDetailView *cdv;

@end

@implementation CommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
    
    [self setupCommentDetailView];
    
    [self requestData];
}

- (void)requestData {
    if (self.requestID.length < 1) {
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comics/%@/comments/0?",self.requestID];
    
    self.cdv.requestUrl = requestUrl;
}

- (void)setupNavBar {
    
    
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:@[@"最新评论",@"最热评论"]];
    
    
    [sc setTintColor:[UIColor lightGrayColor]];
    
    
    NSDictionary *normalTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSDictionary *selectTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [sc setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
    
    [sc setTitleTextAttributes:selectTextAttributes forState:UIControlStateSelected];
    
    [sc addTarget:self action:@selector(selectedSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];

    
    self.navigationItem.titleView = sc;
    
    [sc setSelectedSegmentIndex:0];
    
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithImage:@"ic_nav_delete_normal_17x17_" pressImage:@"ic_nav_delete_pressed_17x17_" target:self action:@selector(dismiss)];
    
    self.navigationItem.leftBarButtonItem = back;
    

}

- (void)setupCommentDetailView {
    
    CommentDetailView *cdv = [[CommentDetailView alloc] init];
    [self.view addSubview:cdv];
    
    
    [cdv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHeight);
    }];
    
    self.cdv = cdv;
}

- (void)selectedSegmentIndex:(UISegmentedControl *)sc
{
    
    
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
