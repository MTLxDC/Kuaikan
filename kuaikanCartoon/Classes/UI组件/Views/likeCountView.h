//
//  likeCountView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface likeCountView : UIButton

@property (nonatomic) BOOL islike;                  //当前状态

@property (nonatomic,copy) NSString *requestID;     //点赞请求ID

@property (nonatomic) NSInteger  likeCount;         //设置赞数

@property (nonatomic,copy) void (^onClick)(likeCountView *btn);


+ (instancetype)likeCountViewWithCount:(NSInteger)count requestID:(NSString *)ID;

@end
