//
//  DCPicScrollViewConfiguration.h
//  DCWebPicScrollView
//
//  Created by dengchen on 16/5/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCPicItemConfiguration.h"



@protocol pageControlProtocol <NSObject>

@required

@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property(nonatomic) BOOL hidesForSinglePage;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@optional

@property(nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nonatomic,strong) UIColor *currentPageIndicatorTintColor;

@end



typedef NS_ENUM(NSUInteger,PageContolAlignment) {
    PageContolAlignmentCenter,
    PageContolAlignmentRight,
};

@interface DCPicScrollViewConfiguration : NSObject

@property (nonatomic,strong) DCPicItemConfiguration *itemConfiguration;

@property (nonatomic) NSTimeInterval timeInterval;

@property (nonatomic,strong) UIView<pageControlProtocol> *page;

@property (nonatomic) PageContolAlignment pageAlignment;

@property (nonatomic) BOOL needAutoScroll;

@property (nonatomic) UIEdgeInsets pageEdgeInsets;


+ (instancetype)defaultConfiguration;

@end


