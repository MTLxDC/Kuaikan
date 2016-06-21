//
//  wordsSequenceView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/9.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMacro.h"

#define wordsSequenceViewHeight UseScaleWithSize(20)

@interface wordsSequenceView : UIView

//选中状态为正序,反之倒序

@property (nonatomic,weak,readonly) UIButton *sortBtn;


@end
