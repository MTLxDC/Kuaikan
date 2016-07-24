//
//  NetWorkTool.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <AFNetworking.h>

/*网络相关
 {result:ok, data:data}
 {result:error,message:""}
 {result:invalidatetoken, message:"token失效"}
 */


static NSString * const NetCode     = @"code";
static NSString * const NetOk       = @"OK";
static NSString * const NetData     = @"data";
static NSString * const NetMessage  = @"message";
static NSString * const HTTPSchema  = @"http:";
static NSString * const HTTPGET     = @"GET";
static NSString * const HTTPPOST    = @"POST";
static NSString * const HTTPDELETE  = @"DELETE";

@interface NetWorkManager : AFHTTPSessionManager

@property (nonatomic,readonly) BOOL hasNetWork;

+ (instancetype)share;

- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                                        url:(NSString *)url
                                 parameters:(id)parameters
                                   complish:(void (^)(id res,NSError *error))complish;


@end
