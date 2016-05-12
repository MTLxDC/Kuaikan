//
//  BaseModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

typedef NS_ENUM(NSUInteger, ModelDataCachingPolicy) {
    ModelDataCachingPolicyDefault,
    ModelDataCachingPolicyReload,
    ModelDataCachingPolicyNoCache,
};


@interface BaseModel : NSObject  <MJCoding,MJKeyValue>

+ (NSArray <NSString *>*)setupDataFieldsIsModelArray:(BOOL *)isModelArray;

+ (void)requestModelDataWithUrlString:(NSString *)urlString
                             complish:(void (^)(id))complish
                             cachingPolicy:(ModelDataCachingPolicy)cachingPolicy;

+ (BOOL)saveModelCache;
+ (void)getModelCache;

@end
