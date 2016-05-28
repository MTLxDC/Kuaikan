//
//  CommentInfoCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsModel;

static NSString * const hotCommentRequestUrlFormat =
@"http://api.kuaikanmanhua.com/v1/comics/%@/comments/0?order=score";

static NSString * const newCommentRequestUrlFormat =
@"http://api.kuaikanmanhua.com/v1/comics/%@/comments/0?";

static NSString * const commentInfoCellName = @"CommentInfoCellIdentifier";

@interface CommentInfoCell : UITableViewCell

@property (nonatomic,strong) CommentsModel *commentsModel;


+ (instancetype)makeCommentInfoCell;

@end
