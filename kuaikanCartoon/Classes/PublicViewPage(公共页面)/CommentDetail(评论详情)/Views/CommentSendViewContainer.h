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

@property (nonatomic,strong) NSNumber *comicID;

@property (nonatomic,weak) id<CommentSendViewContainerDelegate> delegate;

+ (instancetype)showInView:(UIView *)view;
- (instancetype)initInView:(UIView *)view;

+ (instancetype)showWithComicID:(NSNumber *)ID inView:(UIView *)view;
- (instancetype)initWithComicID:(NSNumber *)ID inView:(UIView *)view;

- (void)replyWithUserName:(NSString *)nickName commentID:(NSNumber *)ID;

@end
