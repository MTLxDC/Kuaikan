//
//  wordsModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"

/*
 
 "cover_image_url": "http://i.kuaikanmanhua.com/image/160221/nbk8yhgyx.webp-w750",
 "created_at": 1456019052,
 "id": 9949,
 "likes_count": 332348,
 "status": "published",
 "title": "\u7b2c2\u8bdd \u91cd\u751f",
 "topic_id": 717,
 "updated_at": 1456017897,
 "url": "http://www.kuaikanmanhua.com/comics/9949"
 */

@interface CartonnWordsModel : BaseModel

@property (nonatomic,copy) NSString *cover_image_url;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,strong) NSNumber *likes_count;

@property (nonatomic,strong) NSNumber *topic_id;

@property (nonatomic,strong) NSNumber *updated_at;


@end
