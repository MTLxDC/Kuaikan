//
//  NSString+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

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

- (NSString *)cachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:self.md5_16];
}

//md5 32位 加密 （小写）
- (NSString *)md5_32 {
    
    
    
    const char *cStr = [self UTF8String];
    
    
    
    unsigned char result[32];
    
    
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15],
            
            result[16], result[17],result[18], result[19],
            
            result[20], result[21],result[22], result[23],
            
            result[24], result[25],result[26], result[27],
            
            result[28], result[29],result[30], result[31]];
    
}



//md5 16位加密 （大写）

-(NSString *)md5_16 {
    
    const char *cStr = [self UTF8String];
    
    unsigned char result[16];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
}

@end
