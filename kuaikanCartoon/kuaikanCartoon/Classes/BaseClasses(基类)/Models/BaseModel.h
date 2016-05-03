//
//  BaseModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkManager.h"

@interface BaseModel : NSObject


+ (NetWorkManager *)netWorkTool;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
