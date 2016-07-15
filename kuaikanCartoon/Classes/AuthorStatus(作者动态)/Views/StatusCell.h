//
//  StatusCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedsDataModel;
@class FeedsModel;

static NSString * const statusCellReuseIdentifier = @"StatusCell";

@interface StatusCell : UITableViewCell

@property (nonatomic,strong) FeedsModel *model;

+ (StatusCell *)configureCellWithModel:(FeedsDataModel *)model
                   inTableView:(UITableView *)tableView
                   AtIndexPath:(NSIndexPath *)indexPath;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
