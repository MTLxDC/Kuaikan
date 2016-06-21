//
//  comicsModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bannerInfoModel.h"
#import "topicModel.h"


//{
//    "code": 200,
//    "data": {
//        "banner_info": {
//            "id": 184,
//            "pic": "http://i.kuaikanmanhua.com/image/160504/lef4lpyt6.webp-w640.w",
//            "target_id": 11770,
//            "type": 3
//        },
//        "comments_count": 1433,
//        "cover_image_url": "http://i.kuaikanmanhua.com/image/160504/cyjrmkbhu.webp-w750",
//        "created_at": 1462398604,
//        "id": 11944,
//        "images": [
//                   "http://i.kuaikanmanhua.com/image/160504/h3ezd48ma.webp-w750",
//          ],
//        "is_favourite": false,
//        "is_liked": false,
//        "likes_count": 103726,
//        "next_comic_id": null,
//        "previous_comic_id": 11762,
//        "recommend_count": 0,
//        "status": "published",
//        "title": "\u7b2c2\u8bdd \u6211\u60f3\u5411\u5979\u9053\u8c22",
//        "topic": {
//            "comics_count": 2,
//            "cover_image_url": "http://i.kuaikanmanhua.com/image/160427/ccy441ru1.webp-w750",
//            "created_at": 1461730311,
//            "description": "\u7edd\u7f8e\u6843\u82b1\u5996\u75f4\u5fc3\u5b88\u62a4\u5c0f\u841d\u8389\u2014\u2014\u3010\u72ec\u5bb6/\u6bcf\u5468\u56db\u66f4\u65b0\uff0c\u8d23\u7f16\uff1aNico\u3011",
//            "discover_image_url": null,
//            "id": 785,
//            "label_id": 17,
//            "order": 0,
//            "title": "\u6843\u82b1\u707c",
//            "updated_at": 1461730311,
//            "user": {
//                "avatar_url": "http://i.kuaikanmanhua.com/image/160428/8vodw2jf2.webp-w180.w",
//                "id": 10978521,
//                "nickname": "COMIPAGE",
//                "reg_type": "author"
//            },
//            "vertical_image_url": "http://i.kuaikanmanhua.com/image/160427/aldone5cf.webp-w320.w"
//        },
//        "updated_at": 1462350391,
//        "url": "http://www.kuaikanmanhua.com/comics/11944"
//    },
//    "message": "OK"
//}

@interface comicsModel : BaseModel

@property (nonatomic,strong) bannerInfoModel *banner_info;

@property (nonatomic,strong) NSNumber *comments_count;

@property (nonatomic,copy)   NSString *cover_image_url;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,strong) NSArray *images;

@property (nonatomic) BOOL is_favourite;

@property (nonatomic) BOOL is_liked;

@property (nonatomic,strong) NSNumber *likes_count;

@property (nonatomic,strong) NSNumber *next_comic_id;

@property (nonatomic,strong) NSNumber *previous_comic_id;

@property (nonatomic,strong) NSNumber *recommend_count;

@property (nonatomic,strong) NSNumber *updated_at;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) topicModel *topic;

@property (nonatomic,copy) NSString *url;


@end
