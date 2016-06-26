//
//  bannerModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/15.
//  Copyright © 2016年 name. All rights reserved.
//

#import "bannerModel.h"

@implementation bannerModel

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    *isModelArray = YES;
    return @[@"data",@"banner_group"];
}


@end
