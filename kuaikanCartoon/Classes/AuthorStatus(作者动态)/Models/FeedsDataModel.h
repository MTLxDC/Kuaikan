//
//  FeedsModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"
#import "userModel.h"

//{
//    "likes_count": 9,
//    "updated_at": 1467450419135,
//    "comments_count": 5,
//    "share_url": "http://www.kuaikanmanhua.com/feeds/11992819690921984",
//    "created_at": 1467450419135,
//    "shared_count": 0,
//    "feed_type": 3,
//    "user": {
//        "pub_feed": 1,
//        "reg_type": "author",
//        "avatar_url": "http://i.kuaikanmanhua.com/image/160623/4kjg0gi3z.webp-w180.w",
//        "grade": 1,
//        "nickname": "口可口可",
//        "id": 15321579
//    },
//    "content": {
//        "identity": "38011f43-b782-4634-9fd5-4e70f61c9db2",
//        "images": ["FrVcv7lAp3u8sACv4UGfUtV-Z097", "FhlLHqnqthvoiUb7YtALxerp2EdY", "FttkZqwbe7H9TRKXY-J2djBXFaAj", "Fm-Bw9vxT5cvu0jR3tO70n1drr-I", "Fv3QAiMTXDLMf7SMKBYKaNey08zL", "FiR08xs0VclNW20js_A1E8IzzRDj", "Frg_rsIUhByTGbwAArdkDxOAYmlX", "FpFarzx47LwgmtPeGaS2ZBQ7x7uw", "FoolCFfgFVlKByWqvvuiy9fkKDPg"],
//        "image_base": "http://f1.kkmh.com/",
//        "text": "发几张 后面几集的剧透图线稿，很多读者在问攻受，嗯...开始的时候设计的是汤岑是攻，不过几集下来感觉明显林耀是攻...大家想看谁是攻呢？看看哪边的投票多就谁攻吧！（岑  cen，2声这个读音有点生僻，看到有些读者没读对 haha ）ヽ(^0^)ﾉ"
//    },
//    "feed_id": 11992819690921984,
//    "is_liked": false
//}

@interface FeedsContentModel : BaseModel

@property (nonatomic,copy)   NSString *identity;

@property (nonatomic,strong) NSArray *images;

@property (nonatomic,copy)   NSString *image_base;

@property (nonatomic,copy)   NSString *text;

@end

@interface FeedsModel : BaseModel

@property (nonatomic,strong) NSNumber *likes_count;

@property (nonatomic,strong) NSNumber *updated_at;

@property (nonatomic,strong) NSNumber *comments_count;

@property (nonatomic,copy)   NSString *share_url;

@property (nonatomic,assign) BOOL following;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *shared_count;

@property (nonatomic,strong) NSNumber *feed_type;

@property (nonatomic,strong) userModel *user;

@property (nonatomic,strong) FeedsContentModel *content;

@property (nonatomic,copy)   NSArray<NSURL *> *photoImages; //原图

@property (nonatomic,copy)   NSArray<NSURL *> *thumbImages; //缩略图

@property (nonatomic,strong) NSNumber *feed_id;

@property (nonatomic,assign) BOOL is_liked;

@end

@interface FeedsDataModel : BaseModel

@property (nonatomic,strong) NSNumber *current;

@property (nonatomic,strong) NSNumber *pub_feed;

@property (nonatomic,strong) NSMutableArray  *feeds;

@property (nonatomic,strong) NSNumber *since;

@end


