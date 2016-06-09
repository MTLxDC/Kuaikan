//
//  SummaryListItem.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WordsListView : UITableView

@property (nonatomic,copy) NSString *urlString;

@property (nonatomic) BOOL hasTimeline;     //defaut is NO 

@property (nonatomic,copy) void (^NoDataCallBack)();


@end


