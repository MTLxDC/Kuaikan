//
//  SearchresultsCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
@class searchWordModel;

static CGFloat cellHeight = 80;

@interface SearchResultsCell : UITableViewCell

@property (nonatomic,strong) searchWordModel *model;

+ (instancetype)makeSearchResultsCellWithTableView:(UITableView *)tableView
                                    WithTopicModel:(searchWordModel *)md;

@end
