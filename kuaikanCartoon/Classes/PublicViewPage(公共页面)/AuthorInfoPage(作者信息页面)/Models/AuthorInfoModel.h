//
//  AuthorInfoModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/17.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"
#import "topicModel.h"

//"android": "http://caidan.manyule.com/mobile/download?type=android",
//"avatar_url": "http://i.kuaikanmanhua.com/image/150706/hic40eurt.jpg-w180",
//"grade": 1,
//"id": 641190,
//"follower_cnt": 14231,
//"following": null,
//"ios": "https://appsto.re/cn/6YNo4.i",
//"nickname": "\u597d\u6f2b\u753b",
//"pub_feed": 0,
//"reg_type": "author",
//"site": "http://bbs.manyule.com",
//"topics": [{
//    
//}],
//"update_remind_flag": 1,
//"wechat": "mycomic2015",
//"weibo": "http://weibo.com/haocomic",
//"weibo_name": "\u597d\u6f2b\u753b\u6742\u5fd7"

@interface AuthorInfoModel : BaseModel

@property (nonatomic,copy)   NSString *avatar_url;

@property (nonatomic,strong) NSNumber *bind_phone;

@property (nonatomic,strong) NSNumber *follower_cnt; //粉丝个数

@property (nonatomic,assign) BOOL      following; //是否关注

@property (nonatomic,strong) NSNumber *grade;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,copy)   NSString *intro;

@property (nonatomic,copy)   NSString *u_intro;

@property (nonatomic,copy)   NSString *ios;

@property (nonatomic,copy)   NSString *nickname;

@property (nonatomic,strong) NSNumber *pub_feed;

@property (nonatomic,copy)   NSString *reg_type;

@property (nonatomic,copy)   NSString *site;

@property (nonatomic,strong) NSArray  *topics;

@property (nonatomic,strong) NSNumber *update_remind_flag;

@property (nonatomic,copy)   NSString *wechat;

@property (nonatomic,copy)   NSString *weibo_name;

@end
