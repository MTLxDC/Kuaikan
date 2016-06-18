//
//  AuthorTopicInfoCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/17.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class topicModel;

static NSString * const AuthorTopicInfoCellReuseIdentifier = @"AuthorTopicInfoCell";
static CGFloat AuthorTopicInfoCellHeight = 80.0f;

@interface AuthorTopicInfoCell : UITableViewCell

@property (nonatomic,strong) topicModel *model;

@end
