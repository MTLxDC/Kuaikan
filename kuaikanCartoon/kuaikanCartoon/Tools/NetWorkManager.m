//
//  NetWorkTool.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "NetWorkManager.h"
#import "NSString+Extension.h"

@interface NetWorkManager ()


@end

@implementation NetWorkManager



- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                                        url:(NSString *)url
                                 parameters:(id)parameters
                                   complish:(void (^)(id res,NSError *error))complish {
    
    NSParameterAssert(complish);
    
    
   NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:method URLString:url parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        if (complish) {
            complish(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (complish) {
            complish(nil,error);
        }
        
    }];
    
    [dataTask resume];
    
    return dataTask;
}




+ (instancetype)share
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetWorkManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.requestSerializer.timeoutInterval = 10;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring] ;
        
    }
    return self;
}

- (void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring] ;
}

- (BOOL)hasNetWork {
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

@end
