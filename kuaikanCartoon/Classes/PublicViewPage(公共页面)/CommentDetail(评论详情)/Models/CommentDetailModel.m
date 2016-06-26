//
//  CommentDetailModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/27.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentDetailModel.h"

@implementation CommentDetailModel

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return @[@"data"];
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comments":[CommentsModel class]};
}
@end
