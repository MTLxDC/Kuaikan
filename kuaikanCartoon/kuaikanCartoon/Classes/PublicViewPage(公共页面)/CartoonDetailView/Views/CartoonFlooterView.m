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
    
}
- (IBAction)share:(id)sender {
    
}



- (IBAction)previous:(id)sender {
}
- (IBAction)nextPage:(id)sender {
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
