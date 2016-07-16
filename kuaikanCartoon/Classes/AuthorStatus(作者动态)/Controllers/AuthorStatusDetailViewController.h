//
//  AuthorStatusDetailViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseViewController.h"

@class FeedsModel;

@interface AuthorStatusDetailViewController : BaseViewController

@property (nonatomic,strong) FeedsModel *feed_Model;

@property (nonatomic,assign) CGFloat statusCellHeight;


- (instancetype)initWithFeedsModel:(FeedsModel *)model WithCellHeight:(CGFloat)cellheight;

@end
