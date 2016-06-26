


//
//  topicInfoModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import "topicInfoModel.h"
#import "bannersModel.h"

@implementation topicInfoModel

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    *isModelArray = YES;
    return @[@"data",@"infos"];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"topics" : [topicModel class],
             @"banners": [bannersModel class]};
}

@end
