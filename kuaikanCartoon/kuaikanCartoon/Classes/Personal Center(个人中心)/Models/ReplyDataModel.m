//
//  ReplyCommentsModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "ReplyDataModel.h"

@implementation TargetCommentModel

@end

@implementation TargetComicModel

@end

@implementation ReplyCommentsModel

+ (NSDictionary *)mj_objetctClassInArray {
    return @{@"target_comic":[TargetComicModel class],
             @"target_comment":[TargetCommentModel class]};
}

@end

@implementation ReplyDataModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comments":[ReplyCommentsModel class]};
}

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return @[@"data"];
}

@end
