//
//  SummaryListItem.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/29.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordsListView.h"

@interface SummaryListItem : UICollectionViewCell

@property (nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) BOOL hasNotBeenUpdated;

@end
