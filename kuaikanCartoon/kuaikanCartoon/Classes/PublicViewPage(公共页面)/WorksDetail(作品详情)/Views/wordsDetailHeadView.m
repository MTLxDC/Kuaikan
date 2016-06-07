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

@property (weak, nonatomic) IBOutlet UIButton *likeCount;

@property (weak, nonatomic) IBOutlet UIButton *replyCount;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic)  UIScrollView *scrollView;

@property (nonatomic,assign) BOOL  show;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rigthing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

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
    
    CGFloat offsetY = -[change[NSKeyValueChangeNewKey] CGPointValue].y;
    
    printf("offsetY:%f\n",offsetY);

    [self setHeight:offsetY > navHeight ? offsetY : navHeight];
    
    if (offsetY > navHeight + 20) {
        
        
        if (offsetY < wordsDetailHeadViewHeight) {
            
            CGFloat alpha = 0.0f;

            alpha = (wordsDetailHeadViewHeight * 0.5)/offsetY - 0.3;
            
            self.bluredImageView.alpha = alpha;
            self.maskImageView.alpha = 1 - alpha;
            
        }
        
        self.show = YES;
        
    }else {
        
        self.show = NO;
        self.bluredImageView.alpha = 1;
        self.maskImageView.alpha = 0;
      
    }
    
}

- (CGFloat)textWidth {
    
 return [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,15)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.width;
}

- (void)setShow:(BOOL)show {
    if (_show != show) {
        
      
        
        CGFloat leftConstant = spaceing;
        CGFloat rightContstant = 128;
        
        if (!show) {
            rightContstant =  70;
            leftConstant   = (self.width - [self textWidth]) * 0.5;
        }
        
        self.leading.constant  = leftConstant;
        self.rigthing.constant = rightContstant;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
            self.replyCount.alpha = show;
            self.likeCount.alpha = show;
            
        } completion:^(BOOL finished) {
            self.replyCount.hidden = !show;
            self.likeCount.hidden = !show;
        }];
        
        self.backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:show ? 0.1:0];
        
    }
    _show = show;
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
