//
//  BaseTableViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CommonMacro.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface BaseTableViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak,readonly) UITableView *tableView;


- (void)updata;
- (void)loadMoreData;

@end
