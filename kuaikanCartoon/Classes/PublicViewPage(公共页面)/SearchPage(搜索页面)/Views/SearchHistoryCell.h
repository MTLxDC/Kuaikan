//
//  SearchHistoryCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SearchHistoryCell : UITableViewCell

@property (nonatomic,copy) NSString *history;

@property (nonatomic,copy) void (^deleteBtnOnClick)(SearchHistoryCell *cell);


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
