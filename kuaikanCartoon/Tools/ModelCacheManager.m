
//
//  ModelCacheManager.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//

#import "ModelCacheManager.h"
#import "NSString+Extension.h"
#import "NetWorkManager.h"


@interface ModelCacheManager ()

@property (nonatomic,copy)   NSString *cacheDirectory;

@property (nonatomic,strong) NSFileManager *fileManager;

@property (nonatomic,strong) NSMutableDictionary *modelCache;

@end

@implementation ModelCacheManager


+ (instancetype)manager
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ModelCacheManager alloc] init];
    });
    
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
      NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self selector:@selector(saveCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [center addObserver:self selector:@selector(removeAllCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        self.modelCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeAllCache {
    [self.modelCache removeAllObjects];
}



- (id)cacheForKey:(NSString *)key {
    
    BOOL hasNetWork = [[NetWorkManager share] hasNetWork];
    
    id cache = [self.modelCache objectForKey:key];
    
    if (cache || hasNetWork) return cache;
    
    cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForKey:key]];
    
    return cache;
}

- (void)setCache:(id)aCache forKey:(NSString *)aKey {
    if (aCache) {
        [self.modelCache setObject:aCache forKey:aKey];
    }
}

- (void)removeCacheForKey:(NSString *)key {
    [self.modelCache removeObjectForKey:key];
}

- (void)clearCache {
    
    [self.fileManager removeItemAtPath:self.cacheDirectory error:NULL];
    
    [self.fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
    
}

- (void)saveCache {
    
    [self clearCache];
    
    [self.modelCache enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       BOOL succeeded = [NSKeyedArchiver archiveRootObject:obj toFile:[self cachePathForKey:key]];
        printf("保存磁盘对象%s\n",succeeded ? "成功" : "失败");
    }];
    
}

- (NSString *)cachePathForKey:(NSString *)key {
    return [self.cacheDirectory stringByAppendingPathComponent:key.md5_16];
}


- (NSString *)cacheDirectory {
    
    if (!_cacheDirectory) {
        
        _cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"com.kuaikan.cacheDirectory"];
        
        [self.fileManager createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
       
    }
    return _cacheDirectory;
}

- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

@end
