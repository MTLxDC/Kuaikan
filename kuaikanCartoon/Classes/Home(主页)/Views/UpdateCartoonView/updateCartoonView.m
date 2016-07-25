//
//  updateCartoonView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/1.
//  Copyright © 2016年 name. All rights reserved.
//

#import "updateCartoonView.h"
#import "UIView+Extension.h"
#import "DateManager.h"
#import "CommonMacro.h"

@interface updateCartoonView ()
{
    updateCartoonListView *  _cartoonListView;
}

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
    
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    // 获取今天是星期几
    
    NSInteger week    = [[DateManager share] currentWeek] - 1;  //获取今天是星期几，因为数组是从0开始所以-1
    
    NSInteger newWeek = 0;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger index = 6; index > 1; index--) {
    
        newWeek = week - index;                 //获取后面7天是星期几
        
        if (newWeek < 0) newWeek = 7 + newWeek; //如果小与0,表示是上一个星期,
        
        [arr addObject:weekArray[newWeek]];       //取出对应的日期,并添加到另外个数组内
    }
    
    [arr addObjectsFromArray:@[@"昨天",@"今天"]];
    
    ListViewConfiguration *lc = [ListViewConfiguration new];
    
    lc.labelSelectTextColor = subjectColor;
    lc.labelTextColor = [UIColor darkGrayColor];
    lc.lineColor = subjectColor;
    lc.font = [UIFont systemFontOfSize:12];
    lc.spaceing = SCREEN_WIDTH * 0.05;
    lc.labelWidth = SCREEN_WIDTH * 0.2;
    lc.monitorScrollView = self.cartoonListView;
    lc.hasSelectAnimate = YES;
    
    ListView *lv = [ListView listViewWithFrame:CGRectMake(0, 0,self.width,navigationHeadView_H) TextArray:arr Configuration:lc];
    
    [self addSubview:lv];
    [self addSubview:self.cartoonListView];
    
    self.navigationHeadView = lv;
    
}

- (updateCartoonListView *)cartoonListView {
    if (!_cartoonListView) {
        
        updateCartoonListView *clv = [[updateCartoonListView alloc] initWithFrame:CGRectMake(0, navigationHeadView_H, self.width, self.height - navigationHeadView_H)];
        
        _cartoonListView = clv;
    }
    return _cartoonListView;
}






@end
