//
//  MyFellowWordsCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyFellowWordsCell.h"
#import "FellowTopicsModel.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "CommonMacro.h"

@interface MyFellowWordsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *wordsImage;

@property (weak, nonatomic) IBOutlet UILabel *wordsName;

@property (weak, nonatomic) IBOutlet UILabel *wordsAuthor;

@property (weak, nonatomic) IBOutlet UILabel *wordsTitle;

@end

@implementation MyFellowWordsCell

- (void)setModel:(FellowTopicsModel *)model {
    
    _model = model;
    
    [self.wordsImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]
                       placeholderImage:[UIImage imageNamed:@"ic_common_placeholder_s_73x23_"]];
    
    [self.wordsName setText:model.title];
    [self.wordsTitle setText:model.latest_comic_title];
    [self.wordsAuthor setText:model.user.nickname];
}
+ (instancetype)makeMyFellowWordsCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"MyFellowWordsCell" owner:nil options:nil] firstObject];
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
