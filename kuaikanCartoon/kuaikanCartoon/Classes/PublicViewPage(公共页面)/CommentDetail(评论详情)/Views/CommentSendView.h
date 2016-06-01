//
//  CommentSendView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSendView : UIView

@property (nonatomic,copy) void (^sendMessage)(NSString *message);

+ (instancetype)makeCommentSendView;

- (void)clearText;

@end
