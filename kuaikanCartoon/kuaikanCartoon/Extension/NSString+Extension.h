//
//  NSString+Extension.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)makeTextWithCount:(NSInteger)count;

- (NSDictionary *)getUrlStringParameters;

- (NSString *)cachePath;

- (NSString *)md5_32;

- (NSString *)md5_16;

- (BOOL)isMobile;

+ (NSString *)timeStampWithDate:(NSDate *)date;
+ (NSString *)timeWithTimeStamp:(NSUInteger)timeStamp;

@end
