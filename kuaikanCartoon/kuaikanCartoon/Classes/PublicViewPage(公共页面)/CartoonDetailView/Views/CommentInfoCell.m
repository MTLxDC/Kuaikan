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

@interface CommentInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *releaseTime;
@property (weak, nonatomic) IBOutlet UILabel *CommentContent;
@property (weak, nonatomic) IBOutlet UIButton *likeCount;

@end

@implementation CommentInfoCell


- (IBAction)like:(id)sender {
    
}
- (IBAction)reply:(id)sender {
}

- (IBAction)report:(id)sender {
}

- (void)setCommentsModel:(CommentsModel *)commentsModel {
    _commentsModel = commentsModel;
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:commentsModel.user.avatar_url] placeholderImage:[UIImage imageNamed:@"ic_personal_avatar_83x83_"]];
    
    self.userName.text = commentsModel.user.nickname;
    
    self.releaseTime.text = [[DateManager share] timeWithTimeStamp:commentsModel.created_at.integerValue];
    
    self.CommentContent.text = commentsModel.content;
    
    NSString *likeCount = commentsModel.likes_count.stringValue;
    
    [self.likeCount setTitle:likeCount forState:UIControlStateNormal];
    
}

- (void)awakeFromNib {

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

}


@end
