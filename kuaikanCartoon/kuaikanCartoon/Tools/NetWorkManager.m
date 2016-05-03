//
//  NetWorkTool.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "NetWorkManager.h"
#import "NSString+Extension.h"

@implementation NetWorkManager




- (void)GET_Request:(NSString *)url
           complish:(void (^)(id res,NSError *error))complish;

{
    NSParameterAssert(complish);

    NSString *requstUrl = [[url componentsSeparatedByString:@"?"] firstObject];
    NSDictionary *parameters = [url getUrlStringParameters];
    
    [self GET:requstUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (complish) {
            complish(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complish) {
            complish(nil,error);
        }
        
    }];
    
}

- (void)POST_Request:(NSString *)url
               parameters:(id)parameters
            complish:(void (^)(id res,NSError *error))complish;

{
    NSParameterAssert(complish);
    
    [self POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (complish) {
            complish(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complish) {
            complish(nil,error);
        }
        
    }];
    
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
    }
    return self;
}


@end
