//
//  FeedsModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "FeedsDataModel.h"

@implementation FeedsContentModel

@end

@implementation FeedsModel

@end

@implementation FeedsDataModel

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return @[@"data"];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"feeds" : [FeedsModel class]};
}

@end
