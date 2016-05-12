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
#import <MBProgressHUD.h>


@implementation BaseModel

MJCodingImplementation


+ (NSArray<NSString *> *)setupDataFieldsIsModelArray:(BOOL *)isModelArray {
    return nil;
}


static NSMutableDictionary *_modelCache = nil;


+ (BOOL)saveModelCache {
  return [NSKeyedArchiver archiveRootObject:_modelCache toFile:NSStringFromClass(self).cachePath];
    
}

+ (void)getModelCache {
   _modelCache = [NSKeyedUnarchiver unarchiveObjectWithFile:NSStringFromClass(self).cachePath];
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
    
    if (useMemoryCache) {
        
        id memoryCache = [_modelCache objectForKey:urlString];
        
        if (memoryCache) {                      //内存缓存
            complish(memoryCache);
            return;
        }
        
    }
    
    
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:topWindow animated:YES];
    
    hud.labelText = @"Loading...";
    
    NetWorkManager *manager = [NetWorkManager share];
    
    [manager requestWithMethod:@"GET" url:urlString parameters:nil complish:^(id res, NSError *error) {
        
        if (res == nil || error != nil) {
            complish(error);
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
            [hud hide:YES];
        });
        
        if (saveMemoryCache) {
            [_modelCache setObject:result forKey:urlString];
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
        
        _modelCache = [[NSMutableDictionary alloc] init];
        
    }
}

@end
