//
//  SummaryModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "topicModel.h"
//
//{
//    "status": "published",
//    "label_text": "\u90fd\u5e02",
//    "title": "\u7b2c38\u8bdd \u8fd9\u5c31\u662f\u4f60\u843d\u5728\u6211\u5bb6\u7684\u5c0f\u4e1c\u897f",
//    "url": "http://www.kuaikanmanhua.com/comics/11786",
//    "is_liked": false,
//    "shared_count": 0,
//    "updated_at": 1461811546,
//    "id": 11786,
//    "topic": {
//        "vertical_image_url": "http://i.kuaikanmanhua.com/image/151222/927zahhkt.webp-w320.w",
//        "description": "27\u5c81\u7684\u675c\u745e\u62c9\u81ea\u5df1\u5f00\u4e86\u4e00\u5bb6\u6444\u5f71\u5de5\u4f5c\u5ba4\uff0c\u81f3\u4eca\u5355\u8eab\u7684\u5979\u4f1a\u9047\u5230\u5c5e\u4e8e\u81ea\u5df1\u7684\u767d\u9a6c\u738b\u5b50\u5417\uff1f\u3010\u72ec\u5bb6/\u6bcf\u5468\u4e94\u66f4\u65b0  \u8d23\u7f16\uff1a\u6797\u65e9\u4e0a\u3011",
//        "title": "\u5341\u4e8c\u70b9\u7684\u7070\u59d1\u5a18",
//        "created_at": 1435225130,
//        "updated_at": 1435225130,
//        "order": 100,
//        "label_id": 11,
//        "user": {
//            "avatar_url": "http://i.kuaikanmanhua.com/image/150421/k62wy6wmt.jpg-w180.webp",
//            "nickname": "\u6817\u5b50liz",
//            "id": 32,
//            "reg_type": "weibo"
//        },
//        "cover_image_url": "http://i.kuaikanmanhua.com/image/160318/gcldgycnr.webp-w750",
//        "id": 338,
//        "comics_count": 38,
//        "discover_image_url": null
//    },
//    "info_type": 0,
//    "comments_count": 6486,
//    "label_color": "#b536e3",
//    "cover_image_url": "http://i.kuaikanmanhua.com/image/160428/cm3jau93o.webp-w750",
//    "label_text_color": "#ffffff",
//    "created_at": 1461893419,
//    "likes_count": 266523
//},




@interface SummaryModel : BaseModel

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *label_text;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *url;

@property (nonatomic) BOOL is_liked;

@property (nonatomic,strong) NSNumber *shared_count;

@property (nonatomic,strong) NSNumber *updated_at;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,strong) topicModel *topic;

@property (nonatomic,strong) NSNumber *info_type;

@property (nonatomic,strong) NSNumber *comments_count;

@property (nonatomic,copy) NSString *label_color;

@property (nonatomic,copy) NSString *cover_image_url;

@property (nonatomic,copy) NSString *label_text_color;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *likes_count;

+ (void)requestSummaryModelDataWithUrlString:(NSString *)urlString
                                    complish:(void (^)(id res))complish
                                    useCache:(BOOL)cache
                                    saveData:(BOOL)save;

@end


