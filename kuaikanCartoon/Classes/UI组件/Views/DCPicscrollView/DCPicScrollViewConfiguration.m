//
//  DCPicScrollViewConfiguration.m
//  DCWebPicScrollView
//
//  Created by dengchen on 16/5/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import "DCPicScrollViewConfiguration.h"


@interface pageControl : UIPageControl <pageControlProtocol>

@end

@implementation pageControl

@end


@implementation DCPicScrollViewConfiguration

+ (instancetype)defaultConfiguration {
    
    DCPicScrollViewConfiguration *psvc = [[DCPicScrollViewConfiguration alloc] init];
    
    psvc.needAutoScroll = YES;
    psvc.timeInterval = 3;
    psvc.pageAlignment = PageContolAlignmentRight;
    psvc.itemConfiguration = [DCPicItemConfiguration defaultConfiguration];
    psvc.pageEdgeInsets = UIEdgeInsetsMake(0, 0,5,5);

    pageControl *page = [[pageControl alloc] init];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    page.pageIndicatorTintColor = [UIColor lightGrayColor];

    psvc.page = page;
    
    return psvc;
}

- (void)setPageAlignment:(PageContolAlignment)pageAlignment {
    _pageAlignment = pageAlignment;
    if (pageAlignment != PageContolAlignmentRight) {
        self.itemConfiguration.showBottomView = NO;
    }
}

@end