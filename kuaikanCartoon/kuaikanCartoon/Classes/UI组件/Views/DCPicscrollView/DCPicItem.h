//
//  DCPicItem.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCPicItemConfiguration.h"

@interface DCPicItem : UICollectionViewCell

@property (nonatomic,weak,readonly) UIImageView *imageView;

@property (nonatomic,weak,readonly) UILabel *titleView;

@property (nonatomic,strong) DCPicItemConfiguration *configuration;


@end
