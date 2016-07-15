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
#import "NSString+Extension.h"
#import <Masonry.h>
#import "CommonMacro.h"

static NSString * const contentSizeKeyPath = @"contentSize";


@interface CommentBottomView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commntCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *comentBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leading;

@property (nonatomic,weak)  UIButton *sendBtn;


@end

@implementation CommentBottomView


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == (__bridge void * _Nullable)(self)) {
        
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        if ([self.delegate respondsToSelector:@selector(textView:ContenSizeDidChange:)]) {
            [self.delegate textView:self.commentTextView ContenSizeDidChange:size];
        }
        
    }
    
}


+ (instancetype)commentBottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentBottomView" owner:nil options:nil] firstObject];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSendBtn];
    }
    return self;
}

- (void)setupSendBtn {
    
    UIButton *sendBtn = [[UIButton alloc] init];
    
    sendBtn.hidden = YES;
    
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:subjectColor forState:UIControlStateNormal];
    
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [sendBtn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-8);
        make.width.equalTo(@(42));
    }];
    
    self.sendBtn = sendBtn;
}

- (void)sendSucceeded {
    self.commentTextView.text = nil;
    [self.commentTextView resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(textView:ContenSizeDidChange:)]) {
        [self.delegate textView:self.commentTextView ContenSizeDidChange:self.commentTextView.contentSize];
    }
    
    self.beginComment = NO;
    self.placeBtn.hidden = NO;
    
}

- (void)sendComment:(UIButton *)btn {
    if (self.commentTextView.text.length < 1) return;
    
    if ([self.delegate respondsToSelector:@selector(sendMessage:)]) {
        [self.delegate sendMessage:self.commentTextView.text];
    }
}

- (void)awakeFromNib {
    
    self.commentTextView.delegate = self;
    
    [self.commentTextView cornerRadius:0];
    
    [self.commntCount cornerRadius:0];
    
    [self.commentTextView addObserver:self forKeyPath:contentSizeKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
    
    CALayer *layer = self.commentTextView.layer;
    
    layer.borderColor = [[UIColor alloc] initWithWhite:0.9 alpha:1].CGColor;
    layer.borderWidth = 0.5;
    
}

- (void)setBeginComment:(BOOL)beginComment {
    _beginComment = beginComment;
    
    self.comentBtn.hidden   = beginComment;
    self.shareBtn.hidden    = beginComment;
    self.commntCount.hidden = beginComment;
    self.sendBtn.hidden     = !beginComment;
    
    CGFloat constant = beginComment ? -50 : 8;
    
    self.leading.constant = constant;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (BOOL)becomeFirstResponder {
    return [self.commentTextView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self.commentTextView resignFirstResponder];
    
    return [super resignFirstResponder];

}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeBtn.hidden = textView.text.length > 0;
}


- (void)setRecommend_count:(NSInteger)recommend_count {
    _recommend_count = recommend_count;
    
    NSString *commntCountText = [NSString makeTextWithCount:recommend_count];
    
    CGSize textSize = [commntCountText boundingRectWithSize:CGSizeMake(MAXFLOAT,20)
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:self.commntCount.titleLabel.font} context:nil].size;
    
    [self.commntCount setTitle:commntCountText forState:UIControlStateNormal];
    [self.commntCount setHidden:NO];
    
    self.labelWidth.constant = textSize.width * 1.2 + 10;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.commntCount layoutIfNeeded];
    }];
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
