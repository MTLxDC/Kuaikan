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

@interface CartoonDetailViewController ()

@property (nonatomic,strong) comicsModel *comicsMd;

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation CartoonDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *collectedWorks = [[UIBarButtonItem alloc] initWithTitle:@"全集" style:UIBarButtonItemStylePlain target:self action:@selector(gotoCollectedWorksPage)];
        
    self.navigationItem.rightBarButtonItem = collectedWorks;
    
    [collectedWorks setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:subjectColor}forState:UIControlStateNormal];
    
    [self setupCommentBottomView];
 
    [super setBackItemWithImage:@"ic_nav_back_normal_11x19_" pressImage:@"ic_nav_back_pressed_11x19_"];
    [self.navigationController.navigationBar setBarTintColor:White(0.95)];
    
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.66, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:textView.frame];
    
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
    [textView addSubview:label];
    
    self.titleLabel = label;
    
    self.navigationItem.titleView = textView;
    
    
}


- (void)setCartoonId:(NSString *)cartoonId {
    _cartoonId = cartoonId;
    
 NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/comics/%@?",cartoonId];
    
    weakself(self);
    
    [comicsModel requestComicsDetailModelDataWithUrlString:url complish:^(id res) {
        if ([res isKindOfClass:[NSError class]] || res == nil || weakSelf == nil) {
            DEBUG_Log(@"%@",res);
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.comicsMd = res;
        });
        
    } useCache:YES];
    
}

- (void)setComicsMd:(comicsModel *)comicsMd {
    _comicsMd = comicsMd;
    
    self.titleLabel.text = comicsMd.title;
}

- (void)setupCommentBottomView {
    
    CommentBottomView *cb = [CommentBottomView commentBottomView];
    
    [self.view addSubview:cb];
    
    [cb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
}


- (void)gotoCollectedWorksPage {
    printf("%s\n",__func__);
}


@end
