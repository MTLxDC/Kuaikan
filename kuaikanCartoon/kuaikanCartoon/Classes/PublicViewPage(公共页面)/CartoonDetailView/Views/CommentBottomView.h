//
//  CommentBottomView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentBottomViewDelegate <NSObject>

@optional

- (void)textViewContenSizeDidChange:(CGSize)size;

- (void)showShareView;

- (void)showCommentPage;


@end

@interface CommentBottomView : UIView

@property (nonatomic,assign) NSInteger recommend_count;

@property (nonatomic,weak) id<CommentBottomViewDelegate> delegate;

+ (instancetype)commentBottomView;

@end
