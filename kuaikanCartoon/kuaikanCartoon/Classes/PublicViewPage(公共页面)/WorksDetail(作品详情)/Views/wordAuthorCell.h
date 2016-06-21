//
//  wordAuthorCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/19.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMacro.h"

@class userModel;

#define wordAuthorCellHeight UseScaleWithSize(25)

@interface wordAuthorCell : UITableViewCell

@property (nonatomic,strong) userModel *model;

@end
