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


#define NetCode             @"code"
#define NetOk               @"OK"
#define NetData             @"data"
#define NetMessage          @"message"
#define HTTPSchema          @"http:"
#define HTTPGET             @"GET"
#define HTTPPOST            @"POST"

@interface NetWorkManager : AFHTTPSessionManager

@property (nonatomic,readonly) BOOL hasNetWork;


+ (instancetype)share;

- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                                        url:(NSString *)url
                                 parameters:(id)parameters
                                   complish:(void (^)(id res,NSError *error))complish;


@end
