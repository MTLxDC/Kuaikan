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

+ (void)requestModelDataWithUrlString:(NSString *)urlString
                                     complish:(void (^)(id res))complish
                                     useCache:(BOOL)useCache{
    
    
    
     NSString *savePath = urlString.cachePath;
        
        if (useCache) {
            
            id data = [NSKeyedUnarchiver unarchiveObjectWithFile:savePath];
            
            if (data) {
                complish(data);
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
            
            for (NSInteger index = 0; index < fields.count; index++) res = res[fields[index]];
            
            
            id result = nil;
            
            if (isModelArray) {
                result = [[self class] mj_objectArrayWithKeyValuesArray:res];
            }else {
                result = [[self class] mj_objectWithKeyValues:res];
            }
            
            [NSThread sleepForTimeInterval:arc4random() % 2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                complish(result);
                [hud hide:YES];
            });
            
            [NSKeyedArchiver archiveRootObject:result toFile:savePath];
            
            
        }];
        
    
    
}

+ (void)requestModelDataWithUrlString:(NSString *)urlString complish:(void (^)(id))complish {
    
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
        
        complish(result);
        
        
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
