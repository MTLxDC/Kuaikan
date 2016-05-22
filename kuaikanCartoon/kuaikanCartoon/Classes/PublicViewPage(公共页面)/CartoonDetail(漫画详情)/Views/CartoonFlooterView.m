//
//  CartoonFlooterView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CartoonFlooterView.h"

@interface CartoonFlooterView ()


@property (weak, nonatomic) IBOutlet UILabel *upNumber;



@end

@implementation CartoonFlooterView

- (void)setUpCount:(NSInteger)upCount {
    _upCount = upCount;
    
    self.upNumber.text = [NSString stringWithFormat:@"赞 %zd",upCount];
}

- (IBAction)ThumbsUp:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        self.upCount += 1;
    }else{
        self.upCount -= 1;
    }
    
    
}
- (IBAction)comment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(commentButtonAction)]) {
        [self.delegate commentButtonAction];
    }
}
- (IBAction)share:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showShareView)]) {
        [self.delegate showShareView];
    }
}



- (IBAction)previous:(id)sender {
    if ([self.delegate respondsToSelector:@selector(previousPage)]) {
        [self.delegate previousPage];
    }
}
- (IBAction)nextPage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nextPage)]) {
        [self.delegate nextPage];
    }
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
