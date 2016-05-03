//
//  SummaryModel.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SummaryModel.h"

@implementation userModel



@end

@implementation topicModel


@end

@implementation SummaryModel



+ (void)requestSummaryModelDataWithUrlString:(NSString *)urlString
                        complish:(void (^)(id res))complish;

{
    NetWorkManager *tool = [self netWorkTool];
    
   [tool GET_Request:urlString complish:^(id res, NSError *error) {
      
       if (res == nil || error != nil) {
           complish(error);
           return;
       }
       
       NSDictionary *dict = (NSDictionary *)res;
       
       NSArray *dictArr = dict[@"data"][@"comics"];
       
       NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:dictArr.count];
       
       for (NSDictionary *modelDict in dictArr) {
           SummaryModel *md = [SummaryModel modelWithDict:modelDict];
           [modelArr addObject:md];
       }
       
       complish(modelArr);
       
   }];
}

@end
