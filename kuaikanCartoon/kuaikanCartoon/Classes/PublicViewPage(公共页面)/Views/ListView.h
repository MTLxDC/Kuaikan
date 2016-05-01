//
//  ListView.h
//  购物车
//
//  Created by dengchen on 16/4/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewConfiguration : NSObject

@property (nonatomic,assign) BOOL hasSelectAnimate;

@property (nonatomic,strong) UIColor *labelTextColor;

@property (nonatomic,strong) UIColor *labelSelectTextColor;

@property (nonatomic,strong) UIColor *lineColor;    //线的颜色

@property (nonatomic) CGFloat spaceing; //间距

@property (nonatomic) CGFloat  fontSize; //字体大小

@property (nonatomic) CGSize  labelSize;


+ (instancetype)defaultConfiguration;

@end


@interface ListView : UIView
{
    __weak UIView *_lineView;
    
    NSMutableArray *_titleLabelArray;
    NSMutableArray *_titleLabelFrameArray;
}

@property (nonatomic,copy) NSArray *labelTextArray;

@property (nonatomic,weak,readonly) UILabel *currentSelectLabel;


+ (instancetype)listViewWithFrame:(CGRect)frame
                        TextArray:(NSArray *)textArray
                    Configuration:(ListViewConfiguration *)configuration;

+ (instancetype)listViewWithFrame:(CGRect)frame TextArray:(NSArray *)textArray;


- (instancetype)initWithFrame:(CGRect)frame
                    TextArray:(NSArray *)textArray
                Configuration:(ListViewConfiguration *)configuration;

- (instancetype)initWithFrame:(CGRect)frame TextArray:(NSArray *)textArray;


@end
