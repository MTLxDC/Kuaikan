//
//  CartoonContentCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CartoonContentCell.h"

@implementation CartoonContentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        
        _content = imageView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.content.frame = self.bounds;
}

@end
