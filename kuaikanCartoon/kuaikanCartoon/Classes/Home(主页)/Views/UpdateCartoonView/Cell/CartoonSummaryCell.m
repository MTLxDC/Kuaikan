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
#import <SDWebImageDownloader.h>
#import "UIColor+Extension.h"
#import "NetWorkManager.h"
#import "Color.h"

@interface CartoonSummaryCell ()

@property (weak, nonatomic) IBOutlet UIButton *cateoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *worksName;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIImageView *frontCover;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitle;
@property (weak, nonatomic) IBOutlet UILabel *topCount;
@property (weak, nonatomic) IBOutlet UIImageView *up;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UIImageView *comment;


@property (nonatomic,strong) NSMutableAttributedString *iconString;


@property (nonatomic,assign) BOOL islike;

@property (nonatomic,assign) NSInteger likeCount;


@end

@implementation CartoonSummaryCell




+ (instancetype)cartoonSummaryCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CartoonSummaryCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    
    self.cateoryLabel.layer.cornerRadius  = self.cateoryLabel.bounds.size.height * 0.5;
    self.cateoryLabel.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.up addGestureRecognizer:[self tapWithSel:@selector(upCount)]];
    [self.topCount addGestureRecognizer:[self tapWithSel:@selector(upCount)]];


    [self.comment addGestureRecognizer:[self tapWithSel:@selector(goComment)]];
    [self.commentCount addGestureRecognizer:[self tapWithSel:@selector(goComment)]];
    
    
}

- (UITapGestureRecognizer *)tapWithSel:(SEL)sel
{
    return [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
}

- (void)goComment {
    
    printf("%s\n",__func__);
    
}

- (void)updataIsLikeState {
    
    
    
}

- (void)upCount {
    
    self.userInteractionEnabled = NO;
    
    self.islike = !self.islike;

    
    self.likeCount += (self.islike ? 1 : -1);
    
    
    self.topCount.text = [self makeTextWithCount:self.likeCount];
   
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:15.0f options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.up.transform = CGAffineTransformMakeScale(2, 2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.up.transform = CGAffineTransformIdentity;
            self.userInteractionEnabled = YES;
        }];
        
    }];
    
    
    NetWorkManager *manger = [NetWorkManager manager];
    
    
     NSArray *parameter  = self.islike ? @[@"POST",@"/like"] : @[@"DELETE",@"/like?"];

    
    NSMutableString *newUrl = [self.model.url mutableCopy];
    
    [newUrl appendString:parameter.lastObject];

    [manger requestWithMethod:parameter.firstObject url:newUrl parameters:nil complish:^(id res, NSError *error) {
        NSLog(@"%@ error:%@",res,error);
    }];
    
    
 
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 8;
    [super setFrame:frame];
}
//
//"status": "published",
//"label_text": "\u6821\u56ed",
//"title": "\u7b2c2\u8bdd \u6821\u56ed\u76f4\u64ad\u8f6c\u5b66\u751f",
//"url": "http://www.kuaikanmanhua.com/comics/11755",
//"is_liked": false,
//"shared_count": 0,
//"updated_at": 1461671222,
//"id": 11755,
//"topic": {
//				"vertical_image_url": "http://i.kuaikanmanhua.com/image/160415/3fukh5hqq.webp-w320.w",
//				"description": "\u53ea\u6d3b\u5728\u4eca\u5929\u7684\u65e0\u5398\u5934\u66dd\u5149\u8282\u76ee\u7684\u4e3b\u64ad\u5154\u5b50\u5047\u9762\uff0c\u548c\u56e0\u5154\u5b50\u5047\u9762\u800c\u81ea\u6740\u7684\u4eba\u6c14\u660e\u661f\u7684\u59b9\u59b9\u4e4b\u95f4\u53d1\u751f\u7684\u6545\u4e8b\u3002\u3010\u72ec\u5bb6/\u8fde\u8f7d\u4e2d\uff0c\u8d23\u7f16\uff1a\u5976\u7247\u4fa0\u3011\r\n",
//				"title": "\u533f\u540d\u76f4\u64ad",
//				"created_at": 1460728891,
//				"updated_at": 1460728891,
//				"order": 0,
//				"label_id": 12,
//				"user": {
//                    "avatar_url": "http://i.kuaikanmanhua.com/image/160415/khwdru55f.webp-w180.w",
//                    "nickname": "Team  kyai  jaem",
//                    "id": 10270125,
//                    "reg_type": "author"
//                },
//				"cover_image_url": "http://i.kuaikanmanhua.com/image/160425/kbbg045sw.webp-w750",
//				"id": 775,
//				"comics_count": 4,
//				"discover_image_url": "http://i.kuaikanmanhua.com/image/160423/hjviqz0t5.webp-w750"
//},
//"info_type": 0,
//"comments_count": 6039,
//"label_color": "#2ebf74",
//"cover_image_url": "http://i.kuaikanmanhua.com/image/160426/kqeg44evo.webp-w750",
//"label_text_color": "#ffffff",
//"created_at": 1461720619,
//"likes_count": 269321
//},
- (void)setModel:(SummaryModel *)model {
    
    self.likeCount = model.likes_count.integerValue;
    
    self.topCount.text = [self makeTextWithCount:self.likeCount];
    
    self.commentCount.text = [self makeTextWithCount:model.comments_count.integerValue];
    
    [self.frontCover sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]
                       placeholderImage:[UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"]];
    
    
    [self.cateoryLabel setTitle:model.label_text forState:UIControlStateNormal];
    
    [self.cateoryLabel setBackgroundColor:[UIColor colorWithHexString:model.label_color]];
    
    self.worksName.text = model.topic.title;
    
    NSAttributedString *authorName = [[NSAttributedString alloc] initWithString:model.topic.user.nickname];
    
    [self.iconString appendAttributedString:authorName];
   
    self.authorName.attributedText = self.iconString;
    
    self.chapterTitle.text = model.title;
    
    self.islike = model.is_liked;
    
    _model = model;
        
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

- (NSMutableAttributedString *)iconString {
    if (!_iconString) {
        //附件
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        
        //给附件添加图片
        attachment.image = [UIImage imageNamed:@"home_recommend_cell_author_15x15_"];
        
        _iconString = [[NSMutableAttributedString attributedStringWithAttachment:attachment] mutableCopy];
        
    }
    
    return _iconString;
}


- (void)setIslike:(BOOL)islike {
    _islike = islike;
    
    NSString *imageName = self.islike ? @"ic_details_toolbar_praise_pressed_21x21_":
    @"ic_common_praise_normal_15x15_";
    
    [self.up setImage:[UIImage imageNamed:imageName]];
    
    self.topCount.textColor = self.islike ? subjectColor : [UIColor lightGrayColor];
    

}

@end
