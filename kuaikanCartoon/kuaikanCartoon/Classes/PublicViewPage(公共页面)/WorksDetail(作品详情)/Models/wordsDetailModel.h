//
//  WordsDetailModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"
#import "userModel.h"
/*
 comics_count": 10,
 "comments_count": 398146,
 "cover_image_url": "http://i.kuaikanmanhua.com/image/160318/38xc4g7ht.webp-w750",
 "created_at": 1454759344,
 "description": "\u590d\u4ec7\u9ad8\u4e2d\u7cfb\u5217\u4e4b\u2014\u2014\u300a\u590d\u4ec7\u9ad8\u4e2d2016\u300b\uff01\u7531\u539f\u300a\u590d\u4ec7\u9ad8\u4e2d\u300b\u811a\u672c\u5e08\u4e09\u4e95\u541b\u7ee7\u7eed\u521b\u4f5c2016\u5168\u65b0\u5267\u672c\uff0c\u65b0\u9510\u753b\u624b\u6771\u723a\u62c5\u5f53\u7ed8\u753b\uff0c\u7cbe\u5f69\u5267\u60c5\uff0c\u503c\u5f97\u671f\u5f85\uff01\u3010\u72ec\u5bb6/\u6bcf\u5468\u65e5\u66f4\u65b0  \u8d23\u7f16\uff1a\u534a\u77f3\u3011",
 "discover_image_url": null,
 "id": 717,
 "is_favourite": false,
 "label_id": 17,
 "likes_count": 3879241,
 "order": 1500,
 "sort": 0,
 "title": "\u590d\u4ec7\u9ad8\u4e2d2016",
 "updated_at": 1454759344,
 "user": {
 "avatar_url": "http://i.kuaikanmanhua.com/image/151208/su78yq0z1.jpg-w180.webp",
 "id": 4499211,
 "nickname": "\u6771\u723a",
 "reg_type": "author"
 },
 "vertical_image_url": "http://i.kuaikanmanhua.com/image/160216/al5174j5l.webp-w320.w"
 */

@interface wordsDetailModel : BaseModel

@property (nonatomic,strong) NSArray *comics;

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

@property (nonatomic,strong) NSNumber *sort;

@property (nonatomic,strong) NSNumber *updated_at;



@end
