//
//  CollectionComicModel.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "topicModel.h"

@interface CollectionComicModel : BaseModel

@property (nonatomic,copy)      NSString *cover_image_url;

@property (nonatomic,strong)    NSNumber *created_at;

@property (nonatomic,strong)    NSNumber *ID;

@property (nonatomic,copy)      NSString *status;

@property (nonatomic,copy)      NSString *title;

@property (nonatomic,strong)    topicModel *topic;

@property (nonatomic,strong)    NSNumber *updated_at;

@property (nonatomic,copy)      NSString *url;

@end
