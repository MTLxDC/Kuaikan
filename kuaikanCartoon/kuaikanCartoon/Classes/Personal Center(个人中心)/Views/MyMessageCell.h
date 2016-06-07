//
//  MyMessageCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReplyCommentsModel;

static NSString * const MyMessageCellIdentifier = @"MyMessageCellIdentifier";

@interface MyMessageCell : UITableViewCell

@property (nonatomic,strong) ReplyCommentsModel *model;

+ (instancetype)makeMyMessageCell;

@end
