//
//  ListView.h
//  购物车
//
//  Created by dengchen on 16/4/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@interface ListViewConfiguration : NSObject

@property (nonatomic,assign) BOOL hasSelectAnimate;

@property (nonatomic,strong) UIColor *labelTextColor;

@property (nonatomic,strong) UIColor *labelSelectTextColor;

@property (nonatomic,strong) UIColor *lineColor;    //线的颜色

@property (nonatomic) CGFloat spaceing; //间距

@property (nonatomic,strong) UIFont  *font; //字体

@property (nonatomic) CGFloat  labelWidth;

@property (nonatomic,weak) UIScrollView *monitorScrollView; //监听的ScrollView

@property (nonatomic) CGFloat MonitorScrollViewItemWidth;


+ (instancetype)defaultConfiguration;

@end


@interface ListView : UIView
{
     UIView  *_lineView;
     CALayer *_bottomLine;
    
    NSMutableArray *_titleLabelArray;
    NSMutableArray *_titleLabelFrameCache;
}

@property (nonatomic,copy) NSArray *labelTextArray;

@property (nonatomic,weak,readonly) UILabel *currentSelectLabel;

@property (nonatomic,copy) void (^selectAtIndex)(NSInteger index);

@property (nonatomic,readonly) NSInteger currentIndex;


+ (instancetype)listViewWithFrame:(CGRect)frame
                        TextArray:(NSArray *)textArray
                    Configuration:(ListViewConfiguration *)configuration;

- (instancetype)initWithFrame:(CGRect)frame
                    TextArray:(NSArray *)textArray
                Configuration:(ListViewConfiguration *)configuration;

+ (instancetype)listViewWithFrame:(CGRect)frame TextArray:(NSArray *)textArray;

- (instancetype)initWithFrame:(CGRect)frame TextArray:(NSArray *)textArray;


@end
