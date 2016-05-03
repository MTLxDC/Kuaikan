//
//  BaseModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel


+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self = [self init];
    
    if (self) {
        [super setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        Class modelClass = NSClassFromString([NSString stringWithFormat:@"%@Model",key]);
        id model = [modelClass modelWithDict:value];
        [super setValue:model forKey:key];
        return;
        
    }
    
    [super setValue:value forKey:key];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"] || [key isEqualToString:@"description"]) {
        NSString *newKey = [NSString stringWithFormat:@"diff_%@",key];
        
        [super setValue:value forKey:newKey];
        
    }else {
        //        NSLog(@"undefineKey:%@ value:%@",key,value);
    }
}

+ (NetWorkManager *)netWorkTool {
    return [NetWorkManager share];
}

@end
