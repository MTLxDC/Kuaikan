//
//  CommentBottomView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/5.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CommentBottomView.h"

@interface CommentBottomView ()

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (nonatomic,strong) NSAttributedString *placeText;

@end

@implementation CommentBottomView

+ (instancetype)commentBottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentBottomView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    
    self.commentTextField.attributedPlaceholder = self.placeText;
   
}
- (CGRect)borderRectForBounds:(CGRect)bounds {
    NSLog(@"%@",NSStringFromCGRect(bounds));
    return CGRectZero;
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
