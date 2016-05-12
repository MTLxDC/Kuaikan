//
//  CommentDetailView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentDetailView.h"
#import "CommentInfoCell.h"
#import "CommentsModel.h"
#import "CommonMacro.h"
#import "UIView+Extension.h"

@interface CommentDetailView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *modelArray;

@end

static NSString * const commentInfoCellName = @"CommentInfoCellIdentifier";

@implementation CommentDetailView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self setup];
    }
    
    return self;
}

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
    
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 100.f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellName];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentInfoCell" owner:nil options:nil] firstObject];
    }
    
    cell.commentsModel = self.modelArray[indexPath.row];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)setRequestUrl:(NSString *)requestUrl {
    _requestUrl = requestUrl;
    [self update];
}

- (void)update {
    
    weakself(self);
    
    [CommentsModel requestModelDataWithUrlString:self.requestUrl complish:^(id res) {
        if (weakSelf == nil) {
            return ;
        }
        
        CommentDetailView *sself = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            sself.modelArray = res;
            [sself reloadData];
        });
        
    } cachingPolicy:ModelDataCachingPolicyDefault] ;
    
}





@end
