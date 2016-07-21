//
//  CommentDetailViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserInfoManager.h"

@interface CommentDetailViewController : BaseViewController

@property (nonatomic,copy)   NSNumber *dataRequstID;

@property (nonatomic,assign) commentDataType dataType;

+ (instancetype)showInVc:(UIViewController *)vc
        withDataRequstID:(NSNumber *)ID
            WithDataType:(commentDataType)dataType;


@end
