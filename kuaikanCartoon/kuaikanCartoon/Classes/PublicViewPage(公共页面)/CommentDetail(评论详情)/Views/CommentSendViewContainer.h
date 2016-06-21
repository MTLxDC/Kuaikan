//
//  CommentSendViewContainer.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsModel;
@class CommentSendViewContainer;

@protocol CommentSendViewContainerDelegate <NSObject>

@optional

- (void)sendMessageSucceeded:(CommentsModel *)commentContent;

@end


@interface CommentSendViewContainer : UIView

@property (nonatomic,weak) id<CommentSendViewContainerDelegate> delegate;

+ (instancetype)showWithComicID:(NSNumber *)ID inView:(UIView *)view;
- (instancetype)initWithComicID:(NSNumber *)ID inView:(UIView *)view;

- (void)replyWithCommentModel:(CommentsModel *)commentModel;

@end
