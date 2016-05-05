//
//  SummaryModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SummaryModel.h"
#import "NetWorkManager.h"
#import "NSString+Extension.h"

@implementation SummaryModel

//+ (void)mj_setupReplacedKeyFromPropertyName:(MJReplacedKeyFromPropertyName)replacedKeyFromPropertyName {
//    replacedKeyFromPropertyName = ^NSDictionary *{
//        return @{
//                 @"ID":@"id",
//                 @"desc":@"description"
//                 };
//    };
//}


+ (void)requestSummaryModelDataWithUrlString:(NSString *)urlString
                                    complish:(void (^)(id res))complish
                                    useCache:(BOOL)cache
{
    
    NetWorkManager *tool = [NetWorkManager manager];
    
    NSString *savePath = urlString.cachePath;
    
    if (cache) {
        
        NSArray *modelArray = [NSKeyedUnarchiver unarchiveObjectWithFile:savePath];
        
        if (modelArray) {
            complish(modelArray);
            return;
        }
    }
    
    [tool requestWithMethod:@"GET" url:urlString parameters:nil complish:^(id res, NSError *error) {
        
        if (res == nil || error != nil) {
            complish(error);
            return;
        }
        
        
        NSDictionary *dict = (NSDictionary *)res;
        
        NSArray *dictArr = dict[@"data"][@"comics"];
        
        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:dictArr.count];
        
        
        for (NSDictionary *modelDict in dictArr) {
            
            SummaryModel *md = [SummaryModel mj_objectWithKeyValues:modelDict];
    
            [modelArr addObject:md];
        }
        
        complish(modelArr);
        
        if (cache) {
            [NSKeyedArchiver archiveRootObject:modelArr toFile:savePath];
        }
        
    }];
}

@end
