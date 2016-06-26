//
//  MeiZhouPaiHangItem.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/10.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class topicModel;

@interface MeiZhouPaiHangItem : UIView

@property (nonatomic,strong) topicModel *model;

@property (nonatomic,assign) NSInteger rankingNumber;

@property (nonatomic,assign) BOOL hideLine;


+ (instancetype)makeMeiZhouPaiHangItem;

@end
