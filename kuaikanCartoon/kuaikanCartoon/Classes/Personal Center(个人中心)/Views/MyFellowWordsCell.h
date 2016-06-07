//
//  MyFellowWordsCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FellowTopicsModel;

static NSString * const MyFellowWordsCellName = @"MyFellowWordsCellName";

@interface MyFellowWordsCell : UITableViewCell

@property (nonatomic,strong) FellowTopicsModel *model;

+ (instancetype)makeMyFellowWordsCell;

@end
