//
//  bannersModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseModel.h"

@interface bannersModel : BaseModel

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,strong) NSNumber *target_id;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *target_title;

@property (nonatomic,strong) NSNumber *type;

@end
