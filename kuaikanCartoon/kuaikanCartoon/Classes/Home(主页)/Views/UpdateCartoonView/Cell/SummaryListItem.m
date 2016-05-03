//
//  SummaryListItem.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SummaryListItem.h"
#import "CartoonSummaryCell.h"
#import "CommonMacro.h"
#import "SummaryModel.h"
#import <MJRefresh.h>


@interface SummaryListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *modelArray;

@end


@implementation SummaryListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (!self) return nil;
    
    [self setup];
    
    
    return self;
}

static NSString * const cellIdentifier = @"SummaryCell";

- (void)setup {
    
    self.dataSource = self;
    self.delegate = self;
    self.sectionFooterHeight = 20;
    self.rowHeight = 285;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartoonSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [CartoonSummaryCell cartoonSummaryCell];
    }
    
    cell.model = [self.modelArray objectAtIndex:indexPath.section];
    
    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    
    weakself(self);
    
    [SummaryModel requestSummaryModelDataWithUrlString:urlString complish:^(id res) {
        if ([res isKindOfClass:[NSError class]] || res == nil || weakSelf == nil) {
            NSLog(@"%@",res);
            return ;
        }
        
        weakSelf.modelArray = res;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadData];
        });
        
    }];
    
}

@end

/* SummaryListItem  */

@interface SummaryListItem ()

@property (nonatomic,weak) SummaryListView *slv;

@end

@implementation SummaryListItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        SummaryListView *slv = [[SummaryListView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        [self.contentView addSubview:slv];
        
        self.slv = slv;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.slv.frame = self.bounds;
    
}

- (void)setUrlString:(NSString *)urlString {
    self.slv.urlString = urlString;
}



@end
