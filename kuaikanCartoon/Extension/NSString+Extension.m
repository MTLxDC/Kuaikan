//
//  NSString+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "DateManager.h"

@implementation NSString (Extension)

- (CGFloat)getTextWidthWithFont:(UIFont *)font WithMaxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize
                                   options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

- (CGFloat)getTextWidthWithFont:(UIFont *)font {
    return [self getTextWidthWithFont:font WithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}


- (BOOL)isMobile {
    
    if (self.length != 11) return NO;
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self]
         || [regextestcm evaluateWithObject:self]
         || [regextestct evaluateWithObject:self]
         || [regextestcu evaluateWithObject:self])) {
        return YES;
    }
    
    return NO;
}


+ (NSString *)makeTextWithCount:(NSInteger)count {
    
    NSString *topCountText = nil;
    
    if (count >= 100000) {
        topCountText = [NSString stringWithFormat:@"%zd万",count/10000];
    }else {
        topCountText = [NSString stringWithFormat:@"%zd",count];
    }
    
    return topCountText;
}


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


//md5 32位 加密 （小写）
- (NSString *)md5_32 {
    
    
    
    const char *cStr = [self UTF8String];
    
    
    
    unsigned char result[32];
    
    
    CC_LONG lentgh = (CC_LONG)strlen(cStr);

    CC_MD5( cStr,lentgh, result );
    
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
    
    CC_LONG lentgh = (CC_LONG)strlen(cStr);
    
    CC_MD5(cStr,lentgh, result );
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
}


+ (NSString *)timeStampWithDate:(NSDate *)date {
   return [[DateManager share] timeStampWithDate:date];
}
+ (NSString *)timeWithTimeStamp:(NSUInteger)timeStamp {
    return [[DateManager share] timeWithTimeStamp:timeStamp];
}

@end
