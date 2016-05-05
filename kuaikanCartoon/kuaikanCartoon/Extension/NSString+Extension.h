//
//  NSString+Extension.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSDictionary *)getUrlStringParameters;

- (NSString *)cachePath;

- (NSString *)md5_32;

- (NSString *)md5_16;

@end
