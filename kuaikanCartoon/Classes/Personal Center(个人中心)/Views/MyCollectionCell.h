//
//  MyCollectionCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionComicModel;

static NSString * const MyCollectionCellIdentifier = @"MyCollectionCellIdentifier";

@interface MyCollectionCell : UITableViewCell

@property (nonatomic,strong) CollectionComicModel *model;

+ (instancetype)makeMyCollectionCell;

@end
