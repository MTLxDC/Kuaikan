//
//  likeCountView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface likeCountView : UIButton

@property (nonatomic) BOOL islike;

@property (nonatomic,copy) NSString *requestID;

@property (nonatomic) NSUInteger likeCount;

+ (instancetype)likeCountViewWithCount:(NSInteger)count requestID:(NSString *)ID;

@end
