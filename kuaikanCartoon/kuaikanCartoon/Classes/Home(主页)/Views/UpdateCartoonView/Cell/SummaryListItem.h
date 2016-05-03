//
//  SummaryListItem.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SummaryListView : UITableView

@property (nonatomic,copy) NSString *urlString;


@end


@interface SummaryListItem : UICollectionViewCell

@property (nonatomic,copy) NSString *urlString;

@end
