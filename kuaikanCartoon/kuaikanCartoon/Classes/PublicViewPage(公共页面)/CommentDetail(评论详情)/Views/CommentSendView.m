//
//  CommentSendView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentSendView.h"
#import "UIView+Extension.h"
#import <Masonry.h>
#import "CommonMacro.h"
#import "userModel.h"

@interface CommentSendView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *meassageTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (nonatomic,assign) BOOL isreply;

@property (nonatomic,strong) userModel *user;

@end

static NSString * const contentSizeKeyPath = @"contentSize";

@implementation CommentSendView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == (__bridge void * _Nullable)(self)) {
        
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        [self updateHeightWithContentSizeHeight:size.height];
    }
    
}

- (void)updateHeightWithContentSizeHeight:(CGFloat)h {
    
    NSInteger numberofline = 5;
    CGFloat maxH = self.meassageTextView.font.lineHeight * numberofline;
    
    if (h >= maxH) h = maxH;
    if (h <= bottomBarHeight) h = bottomBarHeight;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setHeight:h];
    }];
    
}

- (void)awakeFromNib {
    [self.meassageTextView cornerRadius:5];
    [self.meassageTextView addObserver:self forKeyPath:contentSizeKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
    [self.meassageTextView setDelegate:self];
}

- (void)dealloc {
    [self.meassageTextView removeObserver:self forKeyPath:contentSizeKeyPath];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeLabel.hidden = textView.text.length > 0;
}

+ (instancetype)makeCommentSendView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentSendView" owner:nil options:nil] firstObject];
}

- (IBAction)sendMessage:(id)sender {
    if (self.meassageTextView.text.length < 1) return;
    
    if (self.sendMessage) {
        self.sendMessage(self.meassageTextView.text);
    }
    
}

- (void)replyWithUserModel:(userModel *)user {
    self.isreply = YES;
    self.user    = user;
}

- (void)clearText {
     self.meassageTextView.text = nil;
    [self textViewDidChange:self.meassageTextView];
    [self updateHeightWithContentSizeHeight:0];
    [self.meassageTextView resignFirstResponder];
}

-(void)setPlaceText:(NSString *)placeText {
    self.placeLabel.text = placeText;
}

- (BOOL)becomeFirstResponder {
    return [self.meassageTextView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    self.placeLabel.text = @"吐槽神马的尽管来";
    [self.meassageTextView resignFirstResponder];
    
    return [super resignFirstResponder];
}

@end
