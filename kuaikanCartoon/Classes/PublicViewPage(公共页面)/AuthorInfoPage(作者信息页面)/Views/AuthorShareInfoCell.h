//
//  AuthorShareInfoCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/18.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthorInfoModel;

static NSString * const AuthorShareInfoCellIdentifier = @"AuthorShareInfoCellIdentifier";

static CGFloat const AuthorShareInfoCellHeight = 40;

@interface AuthorShareInfoCell : UITableViewCell

@property (nonatomic,copy,readonly) NSString *text;

- (void)setText:(NSString *)text atIndex:(NSInteger)index;

@end
