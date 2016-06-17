//
//  topicInfoView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class topicModel;

static CGFloat spaceing = 10;

@interface topicInfoView : UIView

@property (nonatomic,strong) topicModel *model;

+ (void)jiuGongGeLayout:(NSArray<topicInfoView *> *)views WithMaxSize:(CGSize)maxSize WithRow:(NSInteger)row;


@end
