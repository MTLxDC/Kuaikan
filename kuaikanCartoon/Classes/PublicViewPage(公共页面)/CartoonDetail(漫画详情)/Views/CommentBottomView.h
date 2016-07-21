//
//  CommentBottomView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoManager.h"

@interface CommentBottomView : UIView

@property (nonatomic,assign) commentDataType dataType;

@property (nonatomic,strong) NSNumber *commentID;

@property (nonatomic,assign) BOOL beginComment;

@property (nonatomic,assign) NSInteger recommend_count;

+ (instancetype)commentBottomView;

@end
