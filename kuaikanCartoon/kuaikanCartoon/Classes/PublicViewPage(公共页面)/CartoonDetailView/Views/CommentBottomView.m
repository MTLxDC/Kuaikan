//
//  CommentBottomView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentBottomView.h"
#import "CommentDetailViewController.h"
#import "UIView+Extension.h"

static NSString * const contentSizeKeyPath = @"contentSize";


@interface CommentBottomView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commntCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


@end

@implementation CommentBottomView


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == (__bridge void * _Nullable)(self)) {
        
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        if ([self.delegate respondsToSelector:@selector(textViewContenSizeDidChange:)]) {
            [self.delegate textViewContenSizeDidChange:size];
        }
        
    }
    
}


+ (instancetype)commentBottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentBottomView" owner:nil options:nil] firstObject];
}


- (void)awakeFromNib {
    
    self.commentTextView.delegate = self;
    
    [self.commentTextView cornerRadius:0];
    
    [self.commntCount cornerRadius:0];
    
    [self.commentTextView addObserver:self forKeyPath:contentSizeKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
    
}



- (void)textViewDidChange:(UITextView *)textView {
    self.placeBtn.hidden = textView.text.length > 0;
}


- (void)setRecommend_count:(NSInteger)recommend_count {
    _recommend_count = recommend_count;
    NSString *commntCountText = [NSString stringWithFormat:@"%zd",_recommend_count];
    CGSize textSize = [commntCountText boundingRectWithSize:CGSizeMake(MAXFLOAT,20)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:self.commntCount.titleLabel.font} context:nil].size;
    
    self.labelWidth.constant = textSize.width * 1.2 + 10;
    [self.commntCount setTitle:commntCountText forState:UIControlStateNormal];

    [self.commntCount layoutIfNeeded];
}


- (IBAction)share:(id)sender {
}

- (IBAction)gotoCommentPage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showCommentPage)]) {
        [self.delegate showCommentPage];
    }
}

- (void)dealloc {
    [self.commentTextView removeObserver:self forKeyPath:contentSizeKeyPath context:(__bridge void * _Nullable)(self)];
}
@end
