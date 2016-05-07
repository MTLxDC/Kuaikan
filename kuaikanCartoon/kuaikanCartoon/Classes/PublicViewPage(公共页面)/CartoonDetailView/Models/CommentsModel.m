//
//  CommentsModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentsModel.h"
#import "NetWorkManager.h"
#import "NSString+Extension.h"


@implementation CommentsModel


+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    *isModelArray = YES;
    return @[@"data",@"comments"];
}
@end
