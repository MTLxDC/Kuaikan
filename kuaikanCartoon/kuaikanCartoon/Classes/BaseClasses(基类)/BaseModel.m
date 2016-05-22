//
//  BaseModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"
#import "NetWorkManager.h"
#import "NSString+Extension.h"
#import <SVProgressHUD.h>
#import "ModelCacheManager.h"

@implementation BaseModel

MJCodingImplementation


+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return nil;
}



+ (void)requestModelDataWithUrlString:(NSString *)urlString complish:(void (^)(id))complish cachingPolicy:(ModelDataCachingPolicy)cachingPolicy {
    
    
    BOOL useCache = YES;
    BOOL saveMemoryCache = YES;
    
    if (cachingPolicy == ModelDataCachingPolicyReload){
        useCache = NO;
    }else if (cachingPolicy == ModelDataCachingPolicyNoCache) {
        useCache = NO;
        saveMemoryCache = NO;
    }
    
    [self requestModelDataWithUrlString:urlString
                               complish:complish
                               useCache:useCache
                        saveMemoryCache:saveMemoryCache];

}

+ (void)requestModelDataWithUrlString:(NSString *)urlString
                             complish:(void (^)(id))complish
                             useCache:(BOOL)useMemoryCache
                             saveMemoryCache:(BOOL)saveMemoryCache   {
    
    ModelCacheManager *cache = [ModelCacheManager manager];
    
    if (useMemoryCache) {
        
        id memoryCache = [cache cacheForKey:urlString];
        
        if (memoryCache) {                      //内存缓存
            complish(memoryCache);
            return;
        }
        
    }
    
    [SVProgressHUD showWithStatus:@"loading"];
    
    NetWorkManager *manager = [NetWorkManager share];
    
    
    [manager requestWithMethod:@"GET" url:urlString parameters:nil complish:^(id res, NSError *error) {
        
        if (res == nil || error != nil) {
            [SVProgressHUD showErrorWithStatus:
            [NSString stringWithFormat:@"网络提了个问题\n错误代码:%zd",error.code]];
            return;
        }
        
        BOOL isModelArray = false;
        
        NSArray *fields = [self setupDataFieldsIsModelArray:&isModelArray];
        
        for (NSInteger index = 0; index < fields.count; index++) {
            res = res[fields[index]];
        }
        
        id result = nil;
        
        if (isModelArray) {
            result = [[self class] mj_objectArrayWithKeyValuesArray:res];
        }else {
            result = [[self class] mj_objectWithKeyValues:res];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complish(result);
            [SVProgressHUD dismiss];
        });
        
        if (saveMemoryCache) {
            [cache setCache:result forKey:urlString];
        }

    }];

}


+ (void)initialize
{
    if (self == [self class]) {
        [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID":@"id",
                     @"desc":@"description"
                     };
        }];
        
    }
}

@end
