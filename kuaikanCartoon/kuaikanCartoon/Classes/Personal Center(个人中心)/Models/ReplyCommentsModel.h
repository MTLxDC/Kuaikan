//
//  ReplyCommentsModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/7.
//  Copyright © 2016年 name. All rights reserved.
//

//"accused_count": 0,
//"comic_id": 12902,
//"content": "\u8fd9\u4ec0\u4e48\u9b3c",
//"created_at": 1465127800,
//"flag": 0,
//"id": 32169761,
//"likes_count": 0,
//"replied_user_id": 13124241,
//"target_comic": {
//				"cover_image_url": "http://i.kuaikanmanhua.com/image/160604/16hzu81er.webp-w750",
//				"id": 12902,
//				"title": "\u7b2c14\u8bdd \u73ab\u7470\u5c11\u5e74",
//				"topic_title": "\u590d\u4ec7\u9ad8\u4e2d2016"
//},
//"target_comment": {
//				"content": "\u56de\u590d\u6211\u7684\u8bc4\u8bba\uff1a\u5f53\u521d\u5e38\u5e38\u53cd\u53cd\u590d\u590d\u53cd\u53cd\u590d\u590d\u8ba9\u4eba\u70ed\u679c\u7136\u4eba\u53cd\u53cd\u590d\u590d\u4e30\u5bcc\u7b49\u5f85\u53d1\u53cd\u53cd\u590d\u590d\u8ba9\u53d1\u53cd\u53cd\u590d\u590d\u4eba\u53cd\u53cd\u590d\u590d\u53cd\u53cd\u590d\u590d\u6211\u53cd\u53cd\u590d\u590d\u53cd\u53cd\u590d\u590d\u53cd\u53cd\u590d\u590d\u4ed6\u53cd\u590d\u54e5\u54e5\u54e5\u54e5\u4e2a\u53cd\u53cd\u590d\u590d\u53cd\u53cd\u590d\u590d\u521a\u521a\u8fc7\u5b98\u65b9\u5e7f\u544a\u54e5\u54e5\u54e5\u54e5\u54e5\u54e5\u54e5\u54e5\u8fc7",
//				"id": 32169318
//},
//"user": {
//				"avatar_url": "http://i.kuaikanmanhua.com/image/160605/g1o23jl9z.webp-w180.w",
//				"grade": 0,
//				"id": 13963425,
//				"nickname": "\u5929\u4f7f\u7684\u5fae\u7b11_qq",
//				"reg_type": "qq"
//}

#import "BaseModel.h"
#import "userModel.h"

//"cover_image_url": "http://i.kuaikanmanhua.com/image/160604/16hzu81er.webp-w750",
//"id": 12902,
//"title": "\u7b2c14\u8bdd \u73ab\u7470\u5c11\u5e74",
//"topic_title": "\u590d\u4ec7\u9ad8\u4e2d2016"

@interface TargetCommentModel : BaseModel

@property (nonatomic,copy)   NSString *content;

@property (nonatomic,strong) NSNumber *ID;


@end


@interface TargetComicModel : BaseModel

@property (nonatomic,copy)   NSString *cover_image_url;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,copy)   NSString *title;

@property (nonatomic,copy)   NSString *topic_title;


@end

@interface ReplyCommentsModel : BaseModel

@property (nonatomic,strong) NSNumber *accused_count;

@property (nonatomic,strong) NSNumber *comic_id;

@property (nonatomic,copy)   NSString *content;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *flag;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,strong) NSNumber *likes_count;

@property (nonatomic,strong) NSNumber *replied_user_id;

@property (nonatomic,strong) TargetComicModel   *target_comic;

@property (nonatomic,strong) TargetCommentModel *target_comment;

@property (nonatomic,strong) userModel *user;

@end

