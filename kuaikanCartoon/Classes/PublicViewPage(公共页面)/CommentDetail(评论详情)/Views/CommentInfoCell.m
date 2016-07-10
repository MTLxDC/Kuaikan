//
//  CommentInfoCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentInfoCell.h"
#import "CommentsModel.h"
#import "DateManager.h"
#import "likeCountView.h"
#import "CommonMacro.h"
#import <Masonry.h>
#import "UIImageView+Extension.h"
#import "userAuthenticationIcon.h"

@interface CommentInfoCell ()

@property (weak, nonatomic) IBOutlet userAuthenticationIcon *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *releaseTime;
@property (weak, nonatomic) IBOutlet UILabel *CommentContent;
@property (weak, nonatomic) IBOutlet likeCountView *likeCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeCountWidth;

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
    
    [self.userIcon updateIconWithImageUrl:commentsModel.user.avatar_url];
    
    self.userIcon.hasAuthentication = [commentsModel.user.reg_type isEqualToString:reg_Type_Author];
    
    self.userName.text = commentsModel.user.nickname;
    
    self.releaseTime.text = [[DateManager share] conversionTimeStamp:commentsModel.created_at];
    
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
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.CommentContent.preferredMaxLayoutWidth = CGRectGetWidth(self.CommentContent.frame);
    self.userIcon.authenticatIconSize = CGRectGetWidth(self.userIcon.frame) * 0.1;
}

@end
