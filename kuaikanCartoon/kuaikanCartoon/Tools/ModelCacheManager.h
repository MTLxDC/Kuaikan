//
//  ModelCacheManager.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIApplication.h>

@interface ModelCacheManager : NSObject

+ (instancetype)manager;

- (id)cacheForKey:(NSString *)key;

- (void)setCache:(id)aCache forKey:(NSString *)aKey;

- (void)removeCacheForKey:(NSString *)key;

@end
