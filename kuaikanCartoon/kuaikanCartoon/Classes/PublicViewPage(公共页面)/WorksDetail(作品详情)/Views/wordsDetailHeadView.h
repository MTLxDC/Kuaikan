//
//  ParallaxHeaderView.h
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <UIKit/UIKit.h>
#import "wordsDetailModel.h"
#import "CommonMacro.h"

#define wordsDetailHeadViewHeight  200

@interface wordsDetailHeadView : UIView

@property (nonatomic,strong) wordsDetailModel *model;

+ (instancetype)wordsDetailHeadViewWithFrame:(CGRect)frame scorllView:(UIScrollView *)sc;

@end
