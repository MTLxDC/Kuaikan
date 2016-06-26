//
//  MyCollectionCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyCollectionCell.h"
#import "CollectionComicModel.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "CommonMacro.h"

@interface MyCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *wordImage;

@property (weak, nonatomic) IBOutlet UILabel *wordTitle;

@property (weak, nonatomic) IBOutlet UILabel *wordName;

@end

@implementation MyCollectionCell

- (void)setModel:(CollectionComicModel *)model {
    _model = model;
    
    [self.wordImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]
                      placeholderImage:[UIImage imageNamed:@"ic_common_placeholder_s_73x23_"]];
    
    self.wordTitle.text = model.title;
    self.wordName.text  = model.topic.title;
    
}

+ (instancetype)makeMyCollectionCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"MyCollectionCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [self setupBottomLine];
}

- (void)setupBottomLine {
    
    UIView *line = [UIView new];
    
    line.backgroundColor = [[UIColor alloc] initWithWhite:0.9 alpha:1];
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
}


@end
