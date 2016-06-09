//
//  MyMessageCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MyMessageCell.h"
#import "UIView+Extension.h"
#import "Color.h"
#import "CommonMacro.h"
#import "ReplyDataModel.h"
#import "DateManager.h"
#import "WordsDetailViewController.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface MyMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *replyTime;

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

@property (weak, nonatomic) IBOutlet UILabel *replyText;

@property (weak, nonatomic) IBOutlet UILabel *replyContent;

@property (weak, nonatomic) IBOutlet UIImageView *wordsImage;
@property (weak, nonatomic) IBOutlet UILabel *wordsTitle;
@property (weak, nonatomic) IBOutlet UILabel *wordsName;

@property (weak, nonatomic) IBOutlet UIView *replyContentContainer;
@property (weak, nonatomic) IBOutlet UIView *wordsContentContainer;


@end

@implementation MyMessageCell


- (void)setModel:(ReplyCommentsModel *)model {
    _model = model;
    
    self.userName.text      = model.user.nickname;
    self.replyText.text     = model.content;
    self.replyContent.text  = model.target_comment.content;
    
    self.wordsName.text     = model.target_comic.topic_title;
    self.wordsTitle.text    = model.target_comic.title;
    
    NSDate *creatDate       = [NSDate dateWithTimeIntervalSince1970:model.created_at.doubleValue];
    
    [self.replyTime setText:[[DateManager share] conversionDate:creatDate]];
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.user.avatar_url]
                     placeholderImage:[UIImage imageNamed:@"ic_personal_avatar_83x83_"]];
    
    [self.wordsImage sd_setImageWithURL:[NSURL URLWithString:model.target_comic.cover_image_url]
                       placeholderImage:[UIImage imageNamed:@"ic_common_placeholder_s_73x23_"]];

}

+ (instancetype)makeMyMessageCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"MyMessageCell" owner:nil options:nil] firstObject];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.replyText.preferredMaxLayoutWidth    = CGRectGetWidth(self.replyText.frame);
    self.replyContent.preferredMaxLayoutWidth = CGRectGetWidth(self.replyContent.frame);
    
    [super layoutSubviews];
    
}

- (IBAction)replyBtnOnClick:(UIButton *)sender {
}

- (IBAction)gotoWordsPage:(UITapGestureRecognizer *)sender {
    
    WordsDetailViewController *wdVc = [[WordsDetailViewController alloc] init];
    
    wdVc.wordsID = self.model.target_comic.ID.stringValue;
    
  UINavigationController *nav = [self findResponderWithClass:[UINavigationController class]];
    
    [nav pushViewController:wdVc animated:YES];
}



- (void)awakeFromNib {
    
    [self setupBottomLine];
    
    [self.userIcon cornerRadius:0];
    
    CALayer *layer = self.replyBtn.layer;
    
    layer.borderColor = White(0.9).CGColor;
    layer.borderWidth   = 0.5;
    layer.cornerRadius  = 5;
    layer.masksToBounds = YES;
    
    [self.replyContentContainer cornerRadius:5];
    
}

- (void)setupBottomLine {
    
    UIView *line = [UIView new];
    
    line.backgroundColor = White(0.9);
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
}

@end
