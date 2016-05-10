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

@property (nonatomic,strong) AFNetworkReachabilityManager *reachability;

@end

@implementation NetWorkManager



- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               parameters:(id)parameters
                 complish:(void (^)(id res,NSError *error))complish {
    
    NSParameterAssert(complish);
    
    
    [[self dataTaskWithHTTPMethod:method URLString:url parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        if (complish) {
            complish(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (complish) {
            complish(nil,error);
        }
        
    }] resume];
    
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
        
        self.completionQueue = dispatch_queue_create("completionQueue", DISPATCH_QUEUE_SERIAL);
        
        self.reachability = [AFNetworkReachabilityManager sharedManager];
        [self.reachability startMonitoring];
//        self.requestSerializer = [AFJSONRequestSerializer serializer];
//        self.requestSerializer.timeoutInterval = 15.0f;
        
        
    }
    return self;
}





- (bool)isReachable {
    return self.reachability.isReachable;
}

@end
