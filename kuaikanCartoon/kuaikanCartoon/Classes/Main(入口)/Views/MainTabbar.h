//
//  MainTabbar.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabbar : UIView

@property (nonatomic,assign) NSInteger selectItem;

@property (nonatomic,readonly) NSInteger cuurentSelectIndex;

@property (nonatomic,copy) void (^selectAtIndex)(UIButton *btn,NSInteger index);

- (void)addItemWithImageNames:(NSArray *)names;

@end
