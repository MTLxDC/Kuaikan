//
//  NSString+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSDictionary *)getUrlStringParameters
{
    
    NSMutableDictionary *paramters = [[NSMutableDictionary alloc] init];

    NSString *getString = [[self componentsSeparatedByString:@"?"] lastObject];
    
    NSArray *arr = [getString componentsSeparatedByString:@"&"];
    
    if (arr.count < 1) {
        return nil;
    }
    
    for (NSString *param in arr) {
        

      NSArray *params = [param componentsSeparatedByString:@"="];
      NSString *key = [params firstObject];
      NSString *value = [params lastObject];

        [paramters setObject:value forKey:key];
    }
    
    return paramters;
}

@end
