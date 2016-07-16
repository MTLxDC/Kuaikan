//
//  CommentDetailViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, commentDataType) {
    ComicsCommentDataType = 0,  //漫画评论
    FeedsCommentDataType  = 1,  //作者动态评论
};

@interface CommentDetailViewController : BaseViewController

@property (nonatomic,copy)   NSNumber *dataRequstID;

@property (nonatomic,assign) commentDataType dataType;

+ (instancetype)showInVc:(UIViewController *)vc
        withDataRequstID:(NSNumber *)ID
            WithDataType:(commentDataType)dataType;


@end
