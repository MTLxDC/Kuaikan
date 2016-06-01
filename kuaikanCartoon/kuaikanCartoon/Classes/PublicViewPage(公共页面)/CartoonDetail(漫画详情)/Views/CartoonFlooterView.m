//
//  CartoonFlooterView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CartoonFlooterView.h"
#import "comicsModel.h"


@interface CartoonFlooterView ()


@property (weak, nonatomic) IBOutlet UILabel *upNumber;

@property (nonatomic,assign) NSInteger upCount;

@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBtn;
@property (weak, nonatomic) IBOutlet UIView *navView;

@end

@implementation CartoonFlooterView

+ (instancetype)makeCartoonFlooterView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CartoonFlooterView" owner:nil options:nil] firstObject];
}

- (void)setUpCount:(NSInteger)upCount {
    _upCount = upCount;
    
    self.upNumber.text = [NSString stringWithFormat:@"赞 %zd",upCount];
    self.model.likes_count = [NSNumber numberWithInteger:upCount];
    
}

- (void)setModel:(comicsModel *)model {
    _model = model;
    
    self.upCount = model.likes_count.integerValue;
    
    BOOL hasPrevious = model.previous_comic_id != nil;
    BOOL hasNext = model.next_comic_id != nil;
    
    self.navView.hidden = hasPrevious == NO && hasNext == NO;
        
    self.previousBtn.enabled = hasPrevious;
    self.nextPageBtn.enabled = hasNext;

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



@end
