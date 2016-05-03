//
//  updateCartoonView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/1.
//  Copyright © 2016年 name. All rights reserved.
//

#import "updateCartoonView.h"
#import "UIView+Extension.h"
#import "CommonMacro.h"
#import "updateCartoonListView.h"

@interface updateCartoonView ()<UICollectionViewDelegate>

@property (nonatomic,weak) updateCartoonListView *cartoonListView;

@property (nonatomic,weak) ListView *navigationHeadView;

@end

@implementation updateCartoonView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupNavigationHeadView];
        [self setupCartoonListView];
    }
    return self;
}

static const CGFloat navigationHeadView_H = 25;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.navigationHeadView.frame = CGRectMake(0, 0,self.width,navigationHeadView_H);
    self.cartoonListView.frame = CGRectMake(0, navigationHeadView_H, self.width, self.height - navigationHeadView_H);
}




- (void)setupNavigationHeadView {
    
    NSMutableArray *weekArray = [NSMutableArray arrayWithArray:
    @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];

    [calender setTimeZone:timeZone];
    
    NSDateComponents *dc = [calender components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    NSInteger weekday = dc.weekday - 1;
    
    [weekArray replaceObjectAtIndex:weekday withObject:@"今天"];
    
    NSInteger yesterday = weekday - 1 > 0 ? weekday - 1 : weekArray.count - 1;
    
    [weekArray replaceObjectAtIndex:yesterday withObject:@"昨天"];
    
    
    ListViewConfiguration *lc = [ListViewConfiguration new];
    
    lc.hasSelectAnimate = YES;
    lc.labelSelectTextColor = subjectColor;
    lc.labelTextColor = [UIColor darkGrayColor];
    lc.lineColor = subjectColor;
    lc.fontSize = 10.0f;
    lc.spaceing = 20.0f;
    lc.labelSize = CGSizeMake(50, navigationHeadView_H - 1);
    
    ListView *lv = [ListView listViewWithFrame:CGRectMake(0, 0,self.width,navigationHeadView_H) TextArray:weekArray Configuration:lc];
    
    [self addSubview:lv];
        
    self.navigationHeadView = lv;
    
}


- (void)setupCartoonListView {
    
    updateCartoonListView *clv = [[updateCartoonListView alloc] initWithFrame:CGRectMake(0, navigationHeadView_H, self.width, self.height - navigationHeadView_H)];
    
    clv.delegate = self;
    
    [self addSubview:clv];
    
    self.cartoonListView = clv;
    
    
}





@end
