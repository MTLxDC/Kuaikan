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
#import "ProgressHUD.h"
#import "ModelCacheManager.h"
#import "CommonMacro.h"

@implementation BaseModel

MJCodingImplementation


+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return nil;
}

+ (void)requestModelDataWithUrlString:(NSString *)urlString complish:(void (^)(id))complish cachingPolicy:(ModelDataCachingPolicy)cachingPolicy hubInView:(UIView *)view {
    
    
    BOOL useCache = YES;
    BOOL saveCache = YES;
    
    if (cachingPolicy == ModelDataCachingPolicyReload){
        useCache = NO;
    }else if (cachingPolicy == ModelDataCachingPolicyNoCache) {
        useCache = NO;
        saveCache = NO;
    }
    
    [self requestModelDataWithUrlString:urlString
                               complish:complish
                               useCache:useCache
                              saveCache:saveCache
                              hubInView:view];

}


+ (void)requestModelDataWithUrlString:(NSString *)urlString
                             complish:(void (^)(id))complish
                             useCache:(BOOL)useMemoryCache
                             saveCache:(BOOL)saveMemoryCache
                             hubInView:(UIView *)view {
    
    NSArray *needDissmissHubViews = [JGProgressHUD allProgressHUDsInView:view];
    
    for (JGProgressHUD *hub in needDissmissHubViews)  [hub dismiss];
    
    ModelCacheManager *cache = [ModelCacheManager manager];
    
    NetWorkManager *manager = [NetWorkManager share];

    BOOL hasNetWork = [manager hasNetWork];
    
    if (useMemoryCache || !hasNetWork) {

        id memoryCache = [cache cacheForKey:urlString];
        
        if (memoryCache) {                      //内存缓存
            complish(memoryCache);
            return;
        }
        
    }
    
   dissmissCallBack dissmiss = [ProgressHUD showProgressWithStatus:@"loading..." inView:view];
    
    [manager requestWithMethod:@"GET" url:urlString parameters:nil complish:^(id res, NSError *error) {
       
        dissmiss();
        
        if (res == nil || error != nil) {
            
            DEBUG_Log(@"result:%@,error:%@",res,error);
            [ProgressHUD showErrorWithStatus:
             [NSString stringWithFormat:@"网络提了个问题\n错误代码:%zd",error.code]
                                      inView:view];
            complish(nil);
            return;
        }
        
        BOOL isModelArray = false;
        
        NSArray *fields = [self setupDataFieldsIsModelArray:&isModelArray];
        
        for (NSInteger index = 0; index < fields.count; index++) res = res[fields[index]];
        
        id result = nil;
        
        if (isModelArray) {
            result = [[self class] mj_objectArrayWithKeyValuesArray:res];
        }else {
            result = [[self class] mj_objectWithKeyValues:res];
        }
            complish(result);
        
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
