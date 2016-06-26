//
//  AuthorInfoModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/17.
//  Copyright © 2016年 name. All rights reserved.
//

#import "AuthorInfoModel.h"

@implementation AuthorInfoModel

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return @[@"data"];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"topics" : [topicModel class]};
}


@end
