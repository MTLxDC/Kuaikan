//
//  CommentBottomView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentBottomView.h"

@interface CommentBottomView () <UITextViewDelegate>


@property (nonatomic,strong) NSAttributedString *placeText;
@property (weak, nonatomic) IBOutlet UIButton *commntCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;

@end

@implementation CommentBottomView

+ (instancetype)commentBottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentBottomView" owner:nil options:nil] firstObject];
}


- (void)awakeFromNib {
    
//    self.commentTextView.attributedText = self.placeText;
    self.commentTextView.delegate = self;
    
    self.commentTextView.layer.cornerRadius = self.commentTextView.bounds.size.height * 0.5;
    self.commentTextView.layer.masksToBounds = YES;
    
    self.commntCount.layer.cornerRadius = self.commntCount.bounds.size.height * 0.5;
    self.commntCount.layer.masksToBounds = YES;
    
    
}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView {
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    self.commentTextView.attributedText = self.placeText;
//}

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
}

- (NSAttributedString *)placeText {
    if (!_placeText) {
        //附件
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        
        //给附件添加图片
        attachment.image = [UIImage imageNamed:@"ic_details_toolbar_write_comment_16x16_"];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"  "];
        
        NSAttributedString *iconStr = [NSAttributedString attributedStringWithAttachment:attachment] ;
        
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"    发表评论"];
    
        [str appendAttributedString:iconStr];
        [str appendAttributedString:str1];

        _placeText = [str copy];
    }
    
    return _placeText;
}

@end
