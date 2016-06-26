//
//  wordTableViewCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import "wordTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"

@interface wordTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *wordImageView;

@property (weak, nonatomic) IBOutlet UILabel *wordTitleLable;

@property (weak, nonatomic) IBOutlet UIButton *like_Count;

@property (weak, nonatomic) IBOutlet UILabel *creat_Time;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end

@implementation wordTableViewCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageWidth.constant = 120;
}

- (void)setModel:(CartonnWordsModel *)model {
    _model = model;
    
    [self.wordImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:[UIImage imageNamed:@"ic_common_placeholder_l_120x38_"]];
    
    self.wordTitleLable.text = model.title;
    
    [self.like_Count setTitle:[NSString makeTextWithCount:model.likes_count.integerValue] forState:UIControlStateNormal];
    
    self.creat_Time.text = [[NSString timeWithTimeStamp:model.created_at.integerValue] substringFromIndex:5];
    
    [self.like_Count sizeToFit];
    
}
@end
