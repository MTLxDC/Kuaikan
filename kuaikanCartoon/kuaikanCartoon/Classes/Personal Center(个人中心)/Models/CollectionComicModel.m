//
//  CollectionComicModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CollectionComicModel.h"

@implementation CollectionComicModel

+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    *isModelArray = YES;
    return @[@"data",@"comics"];
}

@end
