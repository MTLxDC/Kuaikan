//
//  CommentSendView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class userModel;

@interface CommentSendView : UIView

@property (nonatomic,copy) void (^sendMessage)(NSString *message);

+ (instancetype)makeCommentSendView;

- (void)clearText;

- (void)setPlaceText:(NSString *)placeText;

- (void)replyWithUserModel:(userModel *)user;

@end
