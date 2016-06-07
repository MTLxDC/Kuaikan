//
//  CustomSearchBar.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CustomSearchBar.h"
#import "Color.h"
#import "UIView+Extension.h"


@interface CustomSearchBar ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placeBtnCenterX;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placeBtnLeading;

@property (weak, nonatomic) IBOutlet UIButton *placeBtn;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CustomSearchBar



+ (instancetype)makeCustomSearchBar {
    return [[[NSBundle mainBundle] loadNibNamed:@"CustomSearchBar" owner:nil options:nil] firstObject];
}

- (void)changeSearchText:(NSString *)text {
    self.textField.text = text;
    [self textFieldDidChange:self.textField];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.backgroundColor = subjectColor;
    self.textField.delegate = self;
    [self setTextFieldLeftPadding:self.textField forWidth:25];
    
}



- (IBAction)textFieldDidChange:(id)sender {
    self.placeBtn.titleLabel.hidden = self.textField.text.length > 0;
    if ([self.delegate respondsToSelector:@selector(customSearchBar:textDidChange:)]) {
        [self.delegate customSearchBar:self textDidChange:self.textField.text];
    }
    
}

- (IBAction)cancal:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(customSearchBarNeedDisMiss:)]) {
        [self.delegate customSearchBarNeedDisMiss:self];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self beginOrEndEditing:YES];
    if ([self.delegate respondsToSelector:@selector(customSearchBarDidBeginEditing:)]) {
        [self.delegate customSearchBarDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textField.text.length < 1) {
        [self beginOrEndEditing:NO];
    }
}

- (void)beginOrEndEditing:(BOOL)isbegin {
    
    CGFloat offset = (self.textField.width - self.placeBtn.width) * 0.5;
    
    CGFloat constant = isbegin ? offset : 0;
    
    self.placeBtnCenterX.constant = -constant;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self.textField resignFirstResponder];
    return [super resignFirstResponder];
}

@end
