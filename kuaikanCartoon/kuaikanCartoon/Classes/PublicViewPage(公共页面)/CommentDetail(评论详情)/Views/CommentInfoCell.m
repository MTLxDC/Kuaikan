//
//  CommentInfoCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentInfoCell.h"
#import "CommentsModel.h"
#import <UIImageView+WebCache.h>
#import "DateManager.h"
#import "likeCountView.h"
#import "CommonMacro.h"
#import <Masonry.h>

@interface CommentInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *releaseTime;
@property (weak, nonatomic) IBOutlet UILabel *CommentContent;
@property (weak, nonatomic) IBOutlet likeCountView *likeCount;

@end

@implementation CommentInfoCell

+ (instancetype)makeCommentInfoCell {
  return  [[[NSBundle mainBundle] loadNibNamed:@"CommentInfoCell" owner:nil options:nil] firstObject];
}

- (IBAction)likeEevent:(id)sender {
    self.commentsModel.is_liked = !self.commentsModel.is_liked;
    int upCount = self.commentsModel.is_liked ? 1 : -1;
    self.commentsModel.likes_count = [NSNumber numberWithInteger:self.commentsModel.likes_count.integerValue + upCount];
}
- (IBAction)reply:(id)sender {
}

- (IBAction)report:(id)sender {
}

- (void)setCommentsModel:(CommentsModel *)commentsModel {
    _commentsModel = commentsModel;
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:commentsModel.user.avatar_url] placeholderImage:[UIImage imageNamed:@"ic_personal_avatar_83x83_"]];
    
    self.userName.text = commentsModel.user.nickname;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:commentsModel.created_at.doubleValue];
    
    self.releaseTime.text = [[DateManager share] conversionDate:date];
    
    self.CommentContent.text = commentsModel.content;
    
    self.likeCount.islike    = commentsModel.is_liked;
    self.likeCount.likeCount = commentsModel.likes_count.integerValue;
    self.likeCount.requestID = commentsModel.comic_id.stringValue;

}


- (void)awakeFromNib {

    
    UIView *line = [UIView new];
    
    line.backgroundColor = [[UIColor alloc] initWithWhite:0.9 alpha:1];
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.CommentContent.preferredMaxLayoutWidth = CGRectGetWidth(self.CommentContent.frame);
    
    [super layoutSubviews];

}
@end
