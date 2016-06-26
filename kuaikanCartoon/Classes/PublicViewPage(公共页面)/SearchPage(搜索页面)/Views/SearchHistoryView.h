//
//  SearchHistoryView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/22.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryView : UITableView

@property (nonatomic,copy) void (^needSearchHistory)(NSString *history);

- (void)addHistory:(NSString *)history;

@end
