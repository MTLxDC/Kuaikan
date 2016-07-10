//
//  FeedsTableView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, catalog_type) {
    newsData = 1,
    hotData  = 2,
};

@interface FeedsTableView : UITableView

- (void)updateWithDataType:(catalog_type)dataType;

@end
