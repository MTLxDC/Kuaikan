//
//  bannerModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/15.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"
//
//"pic": "http://i.kuaikanmanhua.com/image/160503/12xa20na7.webp-w750",
//"title": "",
//"type": 3,
//"value": "11760"

@interface bannerModel : BaseModel

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,copy) NSString *value;

@end
