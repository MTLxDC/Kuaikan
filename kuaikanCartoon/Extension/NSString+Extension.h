//
//  NSString+Extension.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)


- (CGFloat)getTextWidthWithFont:(UIFont *)font;
- (CGFloat)getTextWidthWithFont:(UIFont *)font WithMaxSize:(CGSize)maxSize;

+ (NSString *)makeTextWithCount:(NSInteger)count;

- (NSDictionary *)getUrlStringParameters;

- (NSString *)md5_32;

- (NSString *)md5_16;

- (BOOL)isMobile;

+ (NSString *)timeStampWithDate:(NSDate *)date;
+ (NSString *)timeWithTimeStamp:(NSUInteger)timeStamp;

@end
