//
//  CartoonSummaryCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SummaryModel;

@interface CartoonSummaryCell : UITableViewCell

@property (nonatomic,strong) SummaryModel *model;

+ (instancetype)cartoonSummaryCell;

@end
