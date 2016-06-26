//
//  SearchWordModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"
#import "userModel.h"


//"topics": [{
//    "comics_count": 46,
//    "comments_count": 288864,
//    "cover_image_url": "http://i.kuaikanmanhua.com/image/160318/nk3y33w1z.webp-w750",
//    "created_at": 1434131902,
//    "description": "\u518d\u6b21\u9082\u9005\u9752\u6885\u7af9\u9a6c\u7684\u4ed6\uff0c\u89e3\u7981\u601d\u5ff5\u7684\u67b7\u9501\uff0c\u80fd\u83b7\u5f97\u5e78\u798f\u5417\uff1f\u3010\u72ec\u5bb6/\u6bcf\u5468\u4e09\u66f4\u65b0  \u8d23\u7f16\uff1a\u54d1\u94c3lynn\u3011",
//    "discover_image_url": null,
//    "id": 329,
//    "is_favourite": false,
//    "label_id": 3,
//    "likes_count": 8968584,
//    "order": 500,
//    "title": "\u604b\u7231\uff01\u4ece\u4eca\u5929\u5f00\u59cb",
//    "updated_at": 1434131902,
//    "user": {
//        "avatar_url": "http://i.kuaikanmanhua.com/image/150422/qcw449bwr.jpg-w180.webp",
//        "grade": 1,
//        "id": 119649,
//        "nickname": "\u96ea\u68a8",
//        "reg_type": "weibo"
//    },
//    "user_id": 119649,
//    "vertical_image_url": "http://i.kuaikanmanhua.com/image/151223/dbjrvesk3.webp-w320.w"
//}, {

@interface searchWordModel : BaseModel


@property (nonatomic,strong) NSNumber *comics_count;

@property (nonatomic,strong) NSNumber *comments_count;

@property (nonatomic,assign) BOOL is_favourite;

@property (nonatomic,copy)   NSString *cover_image_url;

@property (nonatomic,copy)   NSString *desc;

@property (nonatomic,copy)   NSString *discover_image_url;

@property (nonatomic,copy)   NSString *title;

@property (nonatomic,copy)   NSString *vertical_image_url;

@property (nonatomic,strong) userModel *user;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,strong) NSNumber *label_id;

@property (nonatomic,strong) NSNumber *likes_count;

@property (nonatomic,strong) NSNumber *order;

@property (nonatomic,strong) NSNumber *updated_at;

@end
