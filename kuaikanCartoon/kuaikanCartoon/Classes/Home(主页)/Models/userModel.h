//
//  userModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface userModel : BaseModel

@property (nonatomic,copy)   NSString *avatar_url;

@property (nonatomic,copy)   NSString *nickname;

@property (nonatomic,strong) NSNumber *ID;

@property (nonatomic,copy)   NSString *reg_type;


@end