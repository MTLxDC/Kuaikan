//
//  CartoonFlooterView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CartoonFlooterViewDelegate <NSObject>

@optional

- (void)commentButtonAction;    //开启评论

- (void)previousPage;   //上一篇

- (void)nextPage;   //下一篇

- (void)showShareView;  //显示分享视图

@end

@class comicsModel;

static const CGFloat CartoonFlooterViewHeight = 200.f;

@interface CartoonFlooterView : UIView

@property (nonatomic,weak) id<CartoonFlooterViewDelegate> delegate;

@property (nonatomic,strong) comicsModel *model;


+ (instancetype)makeCartoonFlooterView;

@end


