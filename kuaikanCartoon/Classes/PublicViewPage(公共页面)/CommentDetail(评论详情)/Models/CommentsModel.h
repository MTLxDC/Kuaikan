//
//  CommentsModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"
/*
{
"comic_id": 12020,
"content": "\u554a\u554a\u554a\uff0c\u6709\u5f20\u56fe\u3002\u3002\u3002\u3002\u3002\u3002\ud83d\ude31\ud83d\ude31\ud83d\ude31",
"created_at": 1462607580,
"id": 28280239,
"is_liked": false,
"likes_count": 1,
"replied_comment_id": 0,
"replied_user_id": 0,
"user": {
				"avatar_url": "http://i.kuaikanmanhua.com/image/160504/7c5vo3vca.webp-w180.w",
				"id": 11852450,
				"nickname": "\u8471\u7237\u7237",
				"reg_type": "qq"
}
*/

#import "userModel.h"


@interface CommentsModel : BaseModel

@property (nonatomic,strong) NSNumber *comic_id;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,copy)   NSString *content;

@property (nonatomic)        BOOL is_liked;

@property (nonatomic,strong) NSNumber *likes_count;

@property (nonatomic,strong) NSNumber *replied_comment_id;

@property (nonatomic,strong) NSNumber *replied_user_id;

@property (nonatomic,strong) userModel *user;

@end
