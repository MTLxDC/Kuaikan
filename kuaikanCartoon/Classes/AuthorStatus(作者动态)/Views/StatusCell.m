//
//  StatusCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "StatusCell.h"
#import <Masonry.h>
#import "UIImage+Extension.h"
#import "likeCountView.h"
#import "userAuthenticationIcon.h"
#import "StatusImageContentView.h"
#import "FeedsDataModel.h"

#import "UserInfoManager.h"
#import "DateManager.h"

#import "UIView+Extension.h"
#import "CommentDetailViewController.h"
#import "CommonMacro.h"
#import "NSString+Extension.h"
#import "AuthorInfoViewController.h"

@interface StatusCell ()

@property (nonatomic,weak) UIView *statusContentView;

@property (nonatomic,weak) userAuthenticationIcon *userAuthenticationIcon;

@property (nonatomic,weak) UILabel *userNameLabel;

@property (nonatomic,weak) UIButton *followBtn;

@property (nonatomic,weak) UILabel *contentTextLabel;

@property (nonatomic,weak) StatusImageContentView *imageContentView;

@property (nonatomic,weak) UILabel *timeLabel;

@property (nonatomic,weak) likeCountView *likeCountView;

@property (nonatomic,weak) UIButton *replyCountView;

@end

static CGFloat iconSize = 40;


@implementation StatusCell

+ (StatusCell *)configureCellWithModel:(FeedsDataModel *)model inTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath
{
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:statusCellReuseIdentifier];
    
    cell.model = [model.feeds objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)setModel:(FeedsModel *)model {
    _model = model;
    [self updateUIWithModel:model];
}

- (void)updateUIWithModel:(FeedsModel *)model {
    
    [self.userAuthenticationIcon updateIconWithImageUrl:model.user.avatar_url];
    
    self.userNameLabel.text    = model.user.nickname;
    
    if (self.showFollowBtn)  self.followBtn.hidden = model.following;
    
    self.contentTextLabel.text = model.content.text;
    
    self.likeCountView.islike  = model.is_liked;
    
    self.imageContentView.photoImages = model.photoImages;
    self.imageContentView.thumbImages = model.thumbImages;
    
    self.timeLabel.text = [[DateManager share] conversionTimeStamp:model.created_at];
    
    self.likeCountView.likeCount = model.likes_count.integerValue;
    self.likeCountView.requestID = model.feed_id.stringValue;
    
    NSString *replayCountText = [NSString makeTextWithCount:model.comments_count.integerValue];
    
    [self.replyCountView setTitle:replayCountText forState:UIControlStateNormal];
    
    CGFloat replyCountWidth = [replayCountText getTextWidthWithFont:self.replyCountView.titleLabel.font] + 30;
    
    [self.replyCountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(replyCountWidth));
    }];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat spaceing = SPACEING;
    CGFloat margin = 4;
    
    [self.userAuthenticationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.statusContentView);
        make.width.height.equalTo(@(iconSize));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userAuthenticationIcon.mas_right).offset(margin);
        make.centerY.equalTo(self.userAuthenticationIcon);
        make.right.equalTo(self.statusContentView);
    }];
    
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.statusContentView);
        make.top.equalTo(self.userAuthenticationIcon.mas_bottom).offset(spaceing);
    }];
    
    [self.imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextLabel.mas_bottom).offset(spaceing);
        make.left.equalTo(self.statusContentView);
        make.height.width.equalTo(@0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusContentView);
        make.right.equalTo(self.likeCountView.mas_left).offset(-spaceing);
        make.top.equalTo(self.imageContentView.mas_bottom).offset(spaceing);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusContentView);
        make.bottom.equalTo(self.timeLabel);
        make.width.equalTo(@0);
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-spaceing);
    }];
    
    [self.statusContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(spaceing);
        make.right.equalTo(self.contentView).offset(-spaceing);
        make.bottom.equalTo(self.timeLabel);
    }];
    
    UIView *bottomLine = [UIView new];
    
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.statusContentView).offset(spaceing);
    }];
    
}

- (void)setShowFollowBtn:(BOOL)showFollowBtn {
    if (showFollowBtn == _showFollowBtn) return;
    _showFollowBtn = showFollowBtn;
    if (showFollowBtn && _followBtn == nil) {
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.statusContentView);
            make.centerY.equalTo(self.userAuthenticationIcon);
        }];
        
    }
}

- (UIView *)statusContentView {
    if (!_statusContentView) {
        UIView *statusContentView = [UIView new];
        [self.contentView addSubview:statusContentView];
        _statusContentView = statusContentView;
    }
    return _statusContentView;
}

- (userAuthenticationIcon *)userAuthenticationIcon {
    if (!_userAuthenticationIcon) {
        
        userAuthenticationIcon *icon = [[userAuthenticationIcon alloc] init];
        
        icon.hasAuthentication   = YES;
        icon.authenticatIconSize = iconSize * 0.2;
        [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAuthorInfoVc)]];
        
        [self.statusContentView addSubview:icon];
        
        _userAuthenticationIcon = icon;
        
    }
    return _userAuthenticationIcon;
}

- (void)gotoAuthorInfoVc {
    
    AuthorInfoViewController *aiVc = [[AuthorInfoViewController alloc] init];
    
    aiVc.authorID = self.model.user.ID.stringValue;
    
    [self.myViewController.navigationController pushViewController:aiVc animated:YES];
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:14];
        
        [self.statusContentView addSubview:label];
        
        _userNameLabel = label;
        
    }
    return _userNameLabel;
 }

- (UIButton *)followBtn {
    if (!_followBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:@"ic_me_follow_normal_50x24_"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        [self.statusContentView addSubview:btn];
        
        _followBtn = btn;
    }
    return _followBtn;
}

- (void)follow:(UIButton *)btn {
    
    btn.userInteractionEnabled = NO;
    
    UserInfoManager *user = [UserInfoManager share];
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/feeds/update_following_author?author_id=%@&relation=%d&uid=%@",self.model.user.ID,YES,user.ID];
    
    [UserInfoManager followWithUrl:url isFollow:YES WithfollowCallBack:^(BOOL succeed) {
        btn.hidden = succeed;
        btn.userInteractionEnabled = YES;
    }];
    
}

- (UILabel *)contentTextLabel {
    if (!_contentTextLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = SCREEN_WIDTH - SPACEING * 2;
        
        [self.statusContentView addSubview:label];
        
        _contentTextLabel = label;
    }
    return _contentTextLabel;
}

- (StatusImageContentView *)imageContentView {
    if (!_imageContentView) {
        StatusImageContentView *sicv = [StatusImageContentView makeStatusImageContentView];
        [self.statusContentView addSubview:sicv];
        _imageContentView = sicv;
    }
    return _imageContentView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor lightGrayColor];
        label.numberOfLines = 1;
        
        [self.statusContentView addSubview:label];
        
        _timeLabel = label;
        
    }
    return _timeLabel;
}

- (likeCountView *)likeCountView {
    if (!_likeCountView) {
        likeCountView *lcv = [[likeCountView alloc] init];
        
        weakself(self);
        
        [lcv setOnClick:^(likeCountView *btn) {
            weakSelf.model.is_liked = !weakSelf.model.is_liked;
        }];
        
        [self.statusContentView addSubview:lcv];
        
        _likeCountView = lcv;
    }
    return _likeCountView;
}

- (UIButton *)replyCountView {
    if (!_replyCountView) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [btn setTitleColor:[self.likeCountView titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_common_comment_normal_15x15_"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showCommentVc) forControlEvents:UIControlEventTouchUpInside];
        [self.statusContentView addSubview:btn];
        
        _replyCountView = btn;
    }
    
    return _replyCountView;
}

- (void)showCommentVc {
    [CommentDetailViewController showInVc:self.myViewController
                         withDataRequstID:self.model.feed_id
                             WithDataType:FeedsCommentDataType];
}

@end
