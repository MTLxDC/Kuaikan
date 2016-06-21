//
//  wordsOptionsHeadView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMacro.h"

#define wordsOptionsHeadViewHeight UseScaleWithSize(20)

@interface wordsOptionsHeadView : UIView

@property (nonatomic,copy) void (^lefeBtnClick)(UIButton *btn);

@property (nonatomic,copy) void (^rightBtnClick)(UIButton *btn);


@end
