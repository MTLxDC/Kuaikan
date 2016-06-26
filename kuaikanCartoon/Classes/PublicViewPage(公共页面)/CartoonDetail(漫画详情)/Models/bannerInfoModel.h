//
//  bannerInfoModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface bannerInfoModel : BaseModel

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,strong) NSNumber *target_id;

@property (nonatomic,strong) NSNumber *type;


@end
