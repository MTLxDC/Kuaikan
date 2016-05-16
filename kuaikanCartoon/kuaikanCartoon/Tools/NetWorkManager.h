//
//  NetWorkTool.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@interface NetWorkManager : AFHTTPSessionManager


+ (instancetype)share;

- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
               parameters:(id)parameters
                 complish:(void (^)(id res,NSError *error))complish;


@end
