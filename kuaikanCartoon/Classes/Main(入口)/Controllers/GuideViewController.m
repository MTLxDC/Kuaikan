//
//  GuideViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import "GuideViewController.h"
#import "CommonMacro.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"

@interface GuideViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,copy) NSArray<UIImageView *> *imageViews;

@property (nonatomic,weak) UIButton *openBtn;

@end


static NSInteger const MaxItemCount = 3;

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addItemWithMaxItemCount];
}

- (void)addItemWithMaxItemCount {
    
    NSString *appendStr = nil;
    
    if (ScreenMaxLength > 667.0f) {
        appendStr = @"414x736";
    }else {
        appendStr = @"375x667";
    }
    
    NSMutableArray *imageViews = [[NSMutableArray alloc] initWithCapacity:MaxItemCount];
    
    for (int index = 1; index <= MaxItemCount; index++) {
        
        NSString *imageName = [NSString stringWithFormat:@"guidev3-%d_%@_",index,appendStr];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        
        imageView.image = [UIImage imageNamed:imageName];
        
        [imageViews addObject:imageView];

    }
    
    self.imageViews = imageViews;
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    __block CGFloat x = 0.0f;
    CGFloat Width  = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGFloat maxX = self.imageViews.count * Width;
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(maxX, 0);

    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        x = Width * idx;
        [obj setFrame:CGRectMake(x, 0, Width, height)];
    }];
    
    CGFloat btnWidth = Width * 0.6;
    CGFloat btnHeight = 60;
    CGFloat btnY = height - btnHeight * 2;
    CGFloat btnX = maxX - Width + (Width - btnWidth) * 0.5;
    
    self.openBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    
}

- (void)open {
    
   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   appDelegate.window.rootViewController = [MainTabBarController new];
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {

        self.scrollView = [[UIScrollView alloc] init];
        
        [self.view addSubview:_scrollView];
        
        self.scrollView.pagingEnabled = YES;
        self.scrollView.alwaysBounceVertical = NO;
        
    }
    return _scrollView;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        UIButton *open = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollView addSubview:open];
        open.backgroundColor = [UIColor clearColor];
       [open addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
        _openBtn = open;
    }
    return _openBtn;
}

@end
