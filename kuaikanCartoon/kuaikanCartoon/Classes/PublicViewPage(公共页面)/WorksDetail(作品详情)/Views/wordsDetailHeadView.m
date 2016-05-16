//
//  ParallaxHeaderView.m
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import "wordsDetailHeadView.h"
#import "UIImage+ImageEffects.h"
#import <UIImageView+WebCache.h>
#import "CommonMacro.h"
#import "UIView+Extension.h"

@interface wordsDetailHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *bluredImageView;

@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@property (weak, nonatomic) IBOutlet UIButton *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *replyCount;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property (strong, nonatomic)  UIScrollView *scrollView;

@end

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)



static NSString * const offsetKeyPath = @"contentOffset";


CGFloat const maskHeight = 40.0f;
CGFloat const spaceing   = 8.0f;
CGFloat const btnHeight  = 15.0f;


@implementation wordsDetailHeadView

- (IBAction)follow:(id)sender {
    if ([self.delegate respondsToSelector:@selector(follow)]) {
        [self.delegate follow];
    }
}
- (IBAction)back:(id)sender {
    if ([self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}

+ (instancetype)wordsDetailHeadViewWithFrame:(CGRect)frame scorllView:(UIScrollView *)sc {
    
    wordsDetailHeadView *head = [[[NSBundle mainBundle] loadNibNamed:@"wordsDetailHeadView" owner:nil options:nil] firstObject];
    
    [head setFrame:frame];
    [sc addObserver:head forKeyPath:offsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    head.scrollView = sc;
    
    return head;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGFloat offsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
    CGRect newFrame = self.frame;
    
    printf("offsetY:%f\n",-offsetY);

    if (offsetY <= 0 && -offsetY >= navHeight) {
        
        newFrame.size.height = -offsetY;
        
        CGFloat alpha = 0.0f;

        if (-offsetY < headViewHeight) {
            
            alpha = (headViewHeight * 0.5)/-offsetY - 0.3;

        }
        
        self.bluredImageView.alpha = alpha;
        self.maskImageView.alpha = 1 - alpha;
        
    }else {
        newFrame.size.height = navHeight;
        self.bluredImageView.alpha = 1;
        self.maskImageView.alpha = 0;
    }
    
    CGFloat btnAlpha = 1;
    
    if (-offsetY <= (navHeight + btnHeight + spaceing)) {
        
        btnAlpha  = 0;
        
        if (self.leading.constant == spaceing) {
            self.leading.constant = (self.width - self.titleLabel.width) * 0.5 - spaceing;
        }
        
    }else {
        self.leading.constant = spaceing;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:btnAlpha ? 0.1:0];
        self.replyCount.alpha = btnAlpha;
        self.likeCount.alpha = btnAlpha;
    }];
    
    
    self.frame = newFrame;
}



- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:offsetKeyPath context:nil];
}


- (void)awakeFromNib {
    self.clipsToBounds = YES;
    [self.backBtn cornerRadius:0];
    self.backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
}

- (void)setModel:(wordsDetailModel *)model {
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.cover_image_url];
    
    UIImage *placeImage = [UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"];
    
    [self.imageView sd_setImageWithURL:url placeholderImage:placeImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.bluredImageView.image = [image applyLightEffect];
        
    }];
    
    [self.titleLabel setText:model.title];
    
    [self.replyCount setTitle:[self makeTextWithCount:model.comments_count.integerValue]
                     forState:UIControlStateNormal];
    
    [self.likeCount setTitle:[self makeTextWithCount:model.likes_count.integerValue]
                     forState:UIControlStateNormal];
    
    
}

- (NSString *)makeTextWithCount:(NSInteger)count {
    
    NSString *topCountText = nil;
    
    if (count >= 100000) {
        topCountText = [NSString stringWithFormat:@"%zd万",count/10000];
    }else {
        topCountText = [NSString stringWithFormat:@"%zd",count];
    }
    
    return topCountText;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        return nil;
    }else {
        return result;
    }
    
}

@end
