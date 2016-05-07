//
//  BaseModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>


@interface BaseModel : NSObject  <MJCoding,MJKeyValue>

+ (NSArray <NSString *>*)setupDataFieldsIsModelArray:(BOOL *)isModelArray;

+ (void)requestModelDataWithUrlString:(NSString *)urlString
                             complish:(void (^)(id res))complish
                             useCache:(BOOL)cache;

+ (void)requestModelDataWithUrlString:(NSString *)urlString
                             complish:(void (^)(id res))complish;

@end
