//
//  AuthorInfoHeadView.h
//

//
//  Created by dengchen on 16/6/17.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuthorInfoModel;

static CGFloat const AuthorInfoDetailHeadViewHeight = 200.0f;

@interface AuthorInfoDetailHeadView : UIView

@property (nonatomic,strong) AuthorInfoModel *model;

+ (instancetype)makeAuthorInfoDetailHeadView;


@end
