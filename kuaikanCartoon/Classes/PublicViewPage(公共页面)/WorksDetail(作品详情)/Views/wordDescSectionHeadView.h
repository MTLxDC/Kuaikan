//
//  wordDescSectionHeadView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/19.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wordDescSectionHeadView : UIView

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) void (^needReloadHeight)();


- (CGFloat)myHeight;

@end
