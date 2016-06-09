//
//  updateCartoonView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/1.
//  Copyright © 2016年 name. All rights reserved.
//

#import "updateCartoonView.h"
#import "UIView+Extension.h"
#import "Color.h"
#import "updateCartoonListView.h"
#import "DateManager.h"

@interface updateCartoonView ()<UICollectionViewDelegate>

@property (nonatomic,strong) updateCartoonListView *cartoonListView;

@property (nonatomic,strong) ListView *navigationHeadView;

@end

@implementation updateCartoonView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupNavigationHeadView];

    }
    return self;
}

static const CGFloat navigationHeadView_H = 35;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.navigationHeadView.frame = CGRectMake(0, 0,self.width,navigationHeadView_H);
    self.cartoonListView.frame = CGRectMake(0, navigationHeadView_H, self.width, self.height - navigationHeadView_H);
}




- (void)setupNavigationHeadView {
    
    NSMutableArray *weekArray = [NSMutableArray arrayWithArray:
    @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]];
    
    NSInteger week = [[DateManager share] currentWeek] - 1;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger index = 6; index > 1; index--) {
    
        NSInteger newWeek = week - index;
        
        if (newWeek < 0) newWeek = 7 + newWeek;
        
        [arr addObject:weekArray[newWeek]];
    }
    
    [arr addObjectsFromArray:@[@"昨天",@"今天"]];
    
    ListViewConfiguration *lc = [ListViewConfiguration new];
    
    
    lc.labelSelectTextColor = subjectColor;
    lc.labelTextColor = [UIColor darkGrayColor];
    lc.lineColor = subjectColor;
    lc.fontSize = 12.0f;
    lc.spaceing = 20.0f;
    lc.labelWidth = 50.0f;
    lc.monitorScrollView = self.cartoonListView;
    
    ListView *lv = [ListView listViewWithFrame:CGRectMake(0, 0,self.width,navigationHeadView_H) TextArray:arr Configuration:lc];
    
    [self addSubview:lv];
    [self addSubview:self.cartoonListView];
    
    self.navigationHeadView = lv;
    
}




- (updateCartoonListView *)cartoonListView {
    if (!_cartoonListView) {
        updateCartoonListView *clv = [[updateCartoonListView alloc] initWithFrame:CGRectMake(0, navigationHeadView_H, self.width, self.height - navigationHeadView_H)];
        
        clv.delegate = self;
        
        _cartoonListView = clv;
    }
    return _cartoonListView;
}






@end
