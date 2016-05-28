//
//  CommentDetailModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/27.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentsModel.h"


@interface CommentDetailModel : BaseModel

@property (nonatomic,strong) NSMutableArray *comments;

@property (nonatomic,strong) NSNumber *since;

@end
