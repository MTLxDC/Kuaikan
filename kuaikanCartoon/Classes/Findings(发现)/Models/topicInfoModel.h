//
//  topicInfoModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "topicModel.h"
#import "bannerInfoModel.h"

//"code": 200,
//"data": {
//    "infos": [{
//        "action": "topic_lists/4",
//        "title": "\u4eba\u6c14\u98d9\u5347",
//        "topics": [{
//            "comics_count": 11,
//            "cover_image_url": "http://i.kuaikanmanhua.com/image/160225/ih3oyf6wi.webp-w750",
//            "created_at": 1456372618,
//            "description": "\u5c0f\u5e0c\u5bb6\u91cc\u4f4f\u8fdb\u4e86\u4e00\u4e2a\u5c0f\u7537\u5b69\uff0c\u5979\u4e0d\u77e5\u9053\u8fd9\u4e2a\u7537\u5b69\u5176\u5b9e\u662f\u6df7\u4e16\u5927\u9b54\u738b\u2014\u2014\u800c\u5927\u9b54\u738b\u7684\u76ee\u6807\u5c31\u662f\u5c0f\u5e0c\uff01\u3010\u72ec\u5bb6/\u6bcf\u5468\u65e5\u66f4\u65b0\uff0c\u8d23\u7f16\uff1aNico\u3011",
//            "discover_image_url": null,
//            "id": 735,
//            "is_favourite": false,
//            "label_id": 3,
//            "order": 300,
//            "title": "\u6211\u5bb6\u4f4f\u8fdb\u4e86\u5927\u9b54\u738b",
//            "updated_at": 1456372618,
//            "user": {
//                "avatar_url": "http://i.kuaikanmanhua.com/image/160225/rr57iko90.webp-w180.w",
//                "grade": 1,
//                "id": 8756739,
//                "nickname": "\u771f\u6538",
//                "reg_type": "author"
//            },
//            "user_id": 8756739,
//            "vertical_image_url": "http://i.kuaikanmanhua.com/image/160225/whtwmfzxx.webp-w320.w"
//        }, {
@interface topicInfoModel : BaseModel

@property (nonatomic,copy) NSString *action;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSArray *topics;

@property (nonatomic,copy) NSArray *banners;

@property (nonatomic,strong) NSNumber *type;

@end
