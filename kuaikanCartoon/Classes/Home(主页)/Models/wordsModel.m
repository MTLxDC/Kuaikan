//
//  wordsModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/29.
//  Copyright © 2016年 name. All rights reserved.
//

#import "wordsModel.h"

@implementation wordsModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comics":[SummaryModel class]};
}

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return @[@"data"];
}


@end
