//
//  CommentBottomView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentBottomView : UIView

@property (nonatomic,assign) NSInteger recommend_count;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

+ (instancetype)commentBottomView;

@end
