//
//  wordsOptionsHeadView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat wordsOptionsHeadViewHeight = 40;

@interface wordsOptionsHeadView : UIView

@property (nonatomic,copy) void (^lefeBtnClick)(UIButton *btn);

@property (nonatomic,copy) void (^rightBtnClick)(UIButton *btn);


@end
