//
//  CartoonSummaryCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "CartoonSummaryCell.h"
#import "SummaryModel.h"
#import <UIImageView+WebCache.h>

#import "likeCountView.h"
#import "CommentDetailViewController.h"
#import "UIView+Extension.h"
#import <Masonry.h>
#import "CommonMacro.h"
#import "UIColor+Extension.h"


@interface CartoonSummaryCell ()

@property (weak, nonatomic) IBOutlet UIButton *cateoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *worksName;
@property (weak, nonatomic) IBOutlet UIButton *authorName;
@property (weak, nonatomic) IBOutlet UIImageView *frontCover;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitle;


@property (weak, nonatomic) IBOutlet likeCountView *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *CommentCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagWidth;

@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;

@end

@implementation CartoonSummaryCell


+ (instancetype)cartoonSummaryCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CartoonSummaryCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    
    [self setupBottomLine];
    
    [self.likeCount addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
    self.cateoryLabel.layer.cornerRadius  = self.cateoryLabel.bounds.size.height * 0.5;
    self.cateoryLabel.layer.masksToBounds = YES;
    
    self.frontCover.layer.borderColor = colorWithWhite(0.9).CGColor;
    self.frontCover.layer.borderWidth = SINGLE_LINE_WIDTH;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setupBottomLine {
    
    UIView *line = [UIView new];
    
    line.backgroundColor = [[UIColor alloc] initWithWhite:0.6 alpha:1];
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
}


- (IBAction)goComment {
    
    CommentDetailViewController *cdv = [[CommentDetailViewController alloc] init];
    
    cdv.comicID = self.model.topic.ID;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cdv];
    
    UIViewController *myVc = [self findResponderWithClass:[UIViewController class]];
    
    [myVc presentViewController:nav animated:YES completion:^{
        
    }];
    
}



- (void)like {
    self.model.is_liked = !self.model.is_liked;
    int upCount = self.model.is_liked ? 1 : -1;
    self.model.likes_count = [NSNumber numberWithInteger:self.model.likes_count.integerValue + upCount];
}

- (void)setModel:(SummaryModel *)model {
    _model = model;
    
    self.placeImageView.hidden = NO;

    self.likeCount.likeCount = model.likes_count.integerValue;
    
    self.likeCount.islike = model.is_liked;
    
    self.likeCount.requestID = model.ID.stringValue;
    
    NSString *text = [self makeTextWithCount:model.comments_count.integerValue];
    
    [self.CommentCount setTitle:text forState:UIControlStateNormal];
    
    weakself(self);
    
    [self.frontCover sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        weakSelf.placeImageView.hidden = image && error == nil;

    }];
    
    
    [self.cateoryLabel setTitle:model.label_text forState:UIControlStateNormal];
    
    [self.cateoryLabel setBackgroundColor:[UIColor colorWithHexString:model.label_color]];
    
    CGFloat textWidth = [model.label_text boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:0 attributes:@{NSFontAttributeName:self.cateoryLabel.titleLabel.font} context:nil].size.width;
    
    self.tagWidth.constant = textWidth + 12;
    
    self.worksName.text = model.topic.title;
    
    [self.authorName setTitle:model.topic.user.nickname forState:UIControlStateNormal];
    
    self.chapterTitle.text = model.title;
    
    
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




@end
