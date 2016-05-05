//
//  comicsModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "comicsModel.h"
#import "NetWorkManager.h"
#import "NSString+Extension.h"


@implementation comicsModel

+ (void)requestComicsDetailModelDataWithUrlString:(NSString *)urlString
                                         complish:(void (^)(id res))complish
                                         useCache:(BOOL)cache {
    
    
    
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
        
        NSDictionary *modelDict = dict[@"data"];
        
        comicsModel *md = [comicsModel mj_objectWithKeyValues:modelDict];
        
        complish(md);
        
        if (cache) {
            [NSKeyedArchiver archiveRootObject:md toFile:savePath];
        }
        
    }];
    
    
}


@end
