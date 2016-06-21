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
#import "UserInfoManager.h"
#import "WordsDetailViewController.h"
#import "UrlStringDefine.h"

@interface wordsDetailHeadView () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *bluredImageView;

@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeCount;

@property (weak, nonatomic) IBOutlet UIButton *replyCount;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic)  UIScrollView *scrollView;

@property (nonatomic,assign) BOOL  show;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rigthing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@property (nonatomic,assign) BOOL isFollow;

@property (nonatomic,weak) WordsDetailViewController *myVc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upCountBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyCountBtnWidth;

@end

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static NSString * const offsetKeyPath = @"contentOffset";


CGFloat const maskHeight = 40.0f;
CGFloat const spaceing   = 8.0f;
CGFloat const btnHeight  = 15.0f;


@implementation wordsDetailHeadView


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.isFollow = !self.followBtn.selected;
    }
}

- (void)setIsFollow:(BOOL)isFollow {
    
    _isFollow = isFollow;
    
    BOOL isfollow = _isFollow;
    
    self.followBtn.userInteractionEnabled = NO;
    
    NSString *url = [NSString stringWithFormat:FollowTopicsUrlStringFormat,self.model.ID.stringValue];
    
    weakself(self);
    
    [UserInfoManager followWithUrl:url isFollow:isfollow WithfollowCallBack:^(BOOL succeed) {
        
        if (succeed) {
            weakSelf.model.is_favourite = isfollow;
            weakSelf.followBtn.selected = isfollow;
        }
        
        weakSelf.followBtn.userInteractionEnabled = YES;
    }];
    
}

- (IBAction)follow:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.selected) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否取消关注" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    
    }else {
        
        self.isFollow = !btn.selected;

    }
    
}
- (IBAction)back:(id)sender {
    [[self findResponderWithClass:[UINavigationController class]] popViewControllerAnimated:YES];
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
    
    if (offsetY < 1) return;
    
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
            self.myVc.statusBarStyle = UIStatusBarStyleLightContent;
        }else {
            self.myVc.statusBarStyle = UIStatusBarStyleDefault;
        }
        
        self.leading.constant  = leftConstant;
        self.rigthing.constant = rightContstant;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
            self.replyCount.alpha = show;
            self.likeCount.alpha = show;
            
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
    
    NSString *replyCountText = [self makeTextWithCount:model.comments_count.integerValue];
    NSString *likeCountText = [self makeTextWithCount:model.likes_count.integerValue];

    [self.replyCount setTitle:replyCountText
                     forState:UIControlStateNormal];
    
    [self.likeCount setTitle:likeCountText
                    forState:UIControlStateNormal];
    
    static CGFloat imageWidth = 20;
    
    self.replyCountBtnWidth.constant = [self getTextWidth:replyCountText] + imageWidth;
    
    self.upCountBtnWidth.constant    = [self getTextWidth:likeCountText] + imageWidth;
    
    self.followBtn.selected = model.is_favourite;
    
    self.replyCount.hidden = NO;
    self.likeCount.hidden  = NO;
}

- (CGFloat)getTextWidth:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(self.width, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.likeCount.titleLabel.font} context:nil].size.width + 5;
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

- (WordsDetailViewController *)myVc {
    if (!_myVc) {
         _myVc = [self findResponderWithClass:[WordsDetailViewController class]];
    }
    return _myVc;
}

@end
