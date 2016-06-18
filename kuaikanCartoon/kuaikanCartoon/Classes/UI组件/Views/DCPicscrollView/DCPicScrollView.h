//
//  DCPicScrollView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCPicItem.h"
#import "DCPicScrollViewConfiguration.h"
#import "NSTimer+Control.h"


@class DCPicScrollView;


@protocol DCPicScrollViewDataSource <NSObject>

@required

- (NSUInteger)numberOfItemsInPicScrollView:(DCPicScrollView *)picScrollView;

- (void)picScrollView:(DCPicScrollView *)picScrollView
            needUpdateItem:(DCPicItem *)item
              atIndex:(NSInteger)index;

@end

@protocol DCPicScrollViewDelegate <NSObject>

@optional

- (void)picScrollView:(DCPicScrollView *)picScrollView
           selectItem:(DCPicItem *)item
              atIndex:(NSInteger)index;

@end


@interface DCPicScrollView : UIView


@property (nonatomic,weak) id<DCPicScrollViewDataSource> dataSource;

@property (nonatomic,weak) id<DCPicScrollViewDelegate> delegate;

@property (nonatomic,readonly) NSUInteger currentIndex;

@property (nonatomic,strong,readonly) NSTimer *timer;


//if you not set Configuration,will use defaultConfiguration

+ (instancetype)picScrollViewWithFrame:(CGRect)frame
                     withConfiguration:(DCPicScrollViewConfiguration *)configuration
                        withDataSource:(id<DCPicScrollViewDataSource>)dataSource;

+ (instancetype)picScrollViewWithFrame:(CGRect)frame
                        withDataSource:(id<DCPicScrollViewDataSource>)dataSource;

- (instancetype)initWithFrame:(CGRect)frame
               withDataSource:(id<DCPicScrollViewDataSource>)dataSource;

- (instancetype)initWithFrame:(CGRect)frame
            withConfiguration:(DCPicScrollViewConfiguration *)configuration
               withDataSource:(id<DCPicScrollViewDataSource>)dataSource;

- (void)removeTimer;

- (void)reloadData;

@end



