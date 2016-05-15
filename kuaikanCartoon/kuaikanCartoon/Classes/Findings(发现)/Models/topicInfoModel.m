


//
//  topicInfoModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import "topicInfoModel.h"

@implementation topicInfoModel

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    *isModelArray = YES;
    return @[@"data",@"infos"];
}

+ (void)mj_setupObjectClassInArray:(MJObjectClassInArray)objectClassInArray {
    objectClassInArray = ^NSDictionary *{
        return @{@"topics" : [topicModel class]};
    };
}

@end
