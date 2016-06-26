//
//  wordTableViewCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartonnWordsModel.h"
#import "CommonMacro.h"

#define wordTableViewCellHeight 100

@interface wordTableViewCell : UITableViewCell

@property (nonatomic,strong) CartonnWordsModel *model;

@end
