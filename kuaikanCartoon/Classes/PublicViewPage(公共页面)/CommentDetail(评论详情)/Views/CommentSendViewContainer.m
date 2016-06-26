//
//  CommentSendViewContainer.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/6/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentSendViewContainer.h"
#import <Masonry.h>
#import "CommentSendView.h"
#import "CommonMacro.h"
#import "UserInfoManager.h"
#import "CommentsModel.h"
#import "UIView+Extension.h"

@interface CommentSendViewContainer ()

@property (nonatomic,weak) CommentSendView *sendView;

@property (nonatomic,assign) BOOL isreply;

@property (nonatomic,strong) NSNumber *replyCommentID;

@property (nonatomic,weak) UIView *mySuperView;

@end

@implementation CommentSendViewContainer

+ (instancetype)showInView:(UIView *)view {
    return [[[self class] alloc] initInView:view];
}

- (instancetype)initInView:(UIView *)view {
    
    self = [self initWithFrame:CGRectZero];
    
    self.mySuperView = view;
    
    return self;
    
}

+ (instancetype)showWithComicID:(NSNumber *)ID inView:(UIView *)view {
    return [[[self class] alloc] initWithComicID:ID inView:view];
}

- (instancetype)initWithComicID:(NSNumber *)ID inView:(UIView *)view
{
    self = [self initWithFrame:CGRectZero];
    
    self.comicID = ID;
    self.mySuperView = view;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    
        RegisterNotify(UIKeyboardWillChangeFrameNotification, @selector(keyboardFrameChange:))
        
    }
    return self;
}

- (void)dealloc {
    RemoveNofify
}

- (void)onTap {
    [self.sendView resignFirstResponder];
}

- (void)keyboardFrameChange:(NSNotification *)not {
    
    CGFloat end_Y = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat offset = SCREEN_HEIGHT - end_Y;
    
    if (offset > 0) {
        self.hidden = NO;
    }
    
    [self.sendView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mySuperView).offset(-offset);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha  = offset == 0 ? 0 : 0.6;
        [self.mySuperView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.hidden = offset == 0;
    }];
}


- (void)setupSendViewInView:(UIView *)view {
    
    CommentSendView *csv = [CommentSendView makeCommentSendView];
    [view addSubview:csv];
    
    self.sendView = csv;
    
    [csv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.equalTo(@(bottomBarHeight));
    }];
    
    weakself(self);
    
    [csv setSendMessage:^(NSString *message) {
        [weakSelf userCommentWithMessage:message];
    }];
    
    
}

- (void)replyWithUserName:(NSString *)nickName commentID:(NSNumber *)ID {
    
    self.isreply = YES;
    self.replyCommentID = ID;
    
    NSString *placeText = [NSString stringWithFormat:@"回复@%@",nickName];
    
    [self.sendView becomeFirstResponder];
    [self.sendView setPlaceText:placeText];
    
}

- (void)userCommentWithMessage:(NSString *)message {
    
    NSString *requestID = self.isreply ? self.replyCommentID.stringValue : self.comicID.stringValue;
    
    weakself(self);
    
    [UserInfoManager sendMessage:message isReply:self.isreply withID:requestID withSucceededCallback:^(CommentsModel *resultModel) {
        [[weakSelf sendView] clearText];
        
        if ([weakSelf.delegate respondsToSelector:@selector(sendMessageSucceeded:)]) {
            [weakSelf.delegate sendMessageSucceeded:resultModel];
        }
        
    }];
    
    self.isreply = NO;
}


- (void)setMySuperView:(UIView *)mySuperView {
    if (_mySuperView == mySuperView) return;
    
    _mySuperView = mySuperView;
    
    [mySuperView  addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mySuperView);
    }];
    
    [self setupSendViewInView:mySuperView];
}

@end
