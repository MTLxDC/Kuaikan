//
//  CommentDetailView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentDetailView.h"
#import "CommentInfoCell.h"

@interface CommentDetailView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *modelArray;

@end

static NSString * const commentInfoCellName = @"CommentInfoCell";

@implementation CommentDetailView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}




- (void)setup {
    
    self.dataSource = self;
    self.delegate = self;
    
    [self registerNib:[UINib nibWithNibName:commentInfoCellName bundle:nil] forCellReuseIdentifier:commentInfoCellName];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellName];
    
    cell.commentsModel = self.modelArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
