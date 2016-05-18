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

static NSString * const hotCommentRequestUrlFormat =
@"http://api.kuaikanmanhua.com/v1/comics/%@/comments/0?order=score";

static NSString * const newCommentRequestUrlFormat =
@"http://api.kuaikanmanhua.com/v1/comics/%@/comments/0?";

@implementation CommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
    
    [self setupCommentDetailView];
    
    [self requestCommentDataNewOrHot:YES];
}

- (void)requestCommentDataNewOrHot:(BOOL)isNew {
    
    NSString *requestFormat = isNew ? newCommentRequestUrlFormat : hotCommentRequestUrlFormat;

    NSString *requestUrl = [NSString stringWithFormat:requestFormat,self.requestID];
    
    self.cdv.requestUrl = requestUrl;
}

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
    
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithImage:@"ic_nav_delete_normal_17x17_" pressImage:@"ic_nav_delete_pressed_17x17_" target:self action:@selector(dismiss)];
    
    self.navigationItem.leftBarButtonItem = back;
    

}

- (void)setupCommentDetailView {
    
    CommentDetailView *cdv = [[CommentDetailView alloc] init];
    [self.view addSubview:cdv];
    
    
    [cdv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.cdv = cdv;
}

- (void)selectedSegmentIndex:(UISegmentedControl *)sc
{
    [self requestCommentDataNewOrHot:!sc.selectedSegmentIndex];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
