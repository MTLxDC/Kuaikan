//
//  BaseModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@class UIView;

typedef NS_ENUM(NSUInteger, ModelDataCachingPolicy) {
    ModelDataCachingPolicyDefault,  //使用内存缓存 保存进内存
    ModelDataCachingPolicyReload,   //不是用内存缓存 但是更新内存缓存
    ModelDataCachingPolicyNoCache,
};


@interface BaseModel : NSObject  <MJCoding,MJKeyValue>

+ (NSArray <NSString *>*)setupDataFieldsIsModelArray:(BOOL *)isModelArray;


+ (void)requestModelDataWithUrlString:(NSString *)urlString
                             complish:(void (^)(id))complish
                             cachingPolicy:(ModelDataCachingPolicy)cachingPolicy
                             hubInView:(UIView *)view;  //如果传nil使用keywindow


@end
