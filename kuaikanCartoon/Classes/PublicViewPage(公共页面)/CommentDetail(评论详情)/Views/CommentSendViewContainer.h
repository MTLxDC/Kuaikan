//
//  CommentSendViewContainer.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentDetailViewController.h"

@class CommentsModel;

@protocol CommentSendViewContainerDelegate <NSObject>

@optional

- (void)sendMessageSucceeded:(CommentsModel *)commentContent;

@end


@interface CommentSendViewContainer : UIView

@property (nonatomic,strong) NSNumber *dataRequstID;

@property (nonatomic,weak) id<CommentSendViewContainerDelegate> delegate;

@property (nonatomic,assign) commentDataType dataType;


+ (instancetype)showInView:(UIView *)view;
- (instancetype)initInView:(UIView *)view;

+ (instancetype)showWithID:(NSNumber *)ID
              WithDataType:(commentDataType)dataType
                    inView:(UIView *)view;
- (instancetype)initWithID:(NSNumber *)ID
              WithDataType:(commentDataType)dataType
                    inView:(UIView *)view;

- (void)replyWithUserName:(NSString *)nickName commentID:(NSNumber *)ID;

@end
