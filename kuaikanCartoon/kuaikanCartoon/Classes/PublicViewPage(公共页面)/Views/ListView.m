//
//  ListView.m
//  购物车
//
//  Created by dengchen on 16/4/12.
//  Copyright © 2016年 name. All rights reserved.
//

#import "ListView.h"
#import "CommonMacro.h"
#import "UIView+Extension.h"

@implementation ListViewConfiguration

+ (instancetype)defaultConfiguration {
    
    ListViewConfiguration *lc = [ListViewConfiguration new];
    
    lc.hasSelectAnimate = YES;
    lc.spaceing = 15.0f;
    lc.labelSelectTextColor = [UIColor redColor];
    lc.labelTextColor = [UIColor blackColor];
    lc.lineColor = [UIColor redColor];
    lc.fontSize = 15.0f;
    lc.labelSize = CGSizeZero;
    
    return lc;
}

@end

#define MyWidth self.bounds.size.width

static const CGFloat animateDuration = 0.3f;

static const CGFloat lineHeight = 2.0f;

@interface ListView ()

@property (nonatomic,strong) ListViewConfiguration *configuration;

@property (nonatomic,weak) UIScrollView *scrollView;

@end


@implementation ListView

static NSString * const offsetKeyPath = @"contentOffset";

+ (instancetype)listViewWithFrame:(CGRect)frame
                    TextArray:(NSArray *)textArray
                    Configuration:(ListViewConfiguration *)configuration {
    return [[self alloc] initWithFrame:frame TextArray:textArray Configuration:configuration];
}

+ (instancetype)listViewWithFrame:(CGRect)frame TextArray:(NSArray *)textArray {
    return [[self alloc] initWithFrame:frame TextArray:textArray];
}

- (instancetype)initWithFrame:(CGRect)frame
                    TextArray:(NSArray *)textArray
                Configuration:(ListViewConfiguration *)configuration {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
#pragma mark 执行顺序不能错
        
        self.configuration = configuration;
        
        if (self.configuration.scrollView) {
            [self.configuration.scrollView addObserver:self forKeyPath:offsetKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
        }
        
        [self setupSubviews];

        self.labelTextArray = textArray;
        
    }

    
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:offsetKeyPath]&&context == (__bridge void *)self) {
        
//        CGFloat offsetX = [change[NSKeyValueChangeNewKey] CGPointValue].x;
        
        
        
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame TextArray:(NSArray *)textArray {
    
    ListView *listView = [[ListView alloc] initWithFrame:frame];
    
    listView.labelTextArray = textArray;

    return listView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews {
    
    [self setupScrollView];
    [self setupLineView];
    [self setupBottomView];

}

- (void)setupScrollView {
    
    UIScrollView *sc = [UIScrollView new];
    sc.showsHorizontalScrollIndicator = NO;
    sc.bounces = NO;

    [self addSubview:sc];
    
    self.scrollView = sc;
}

- (void)setupBottomView {
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    line.frame = CGRectMake(0,self.height,self.width,0.5);
    
    [self.layer addSublayer:line];
}


- (void)setupLineView {
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = self.configuration.lineColor;
    [self.scrollView addSubview:lineView];
    
    _lineView = lineView;
}

- (void)setupTitleLabel{
    
    _titleLabelArray = [[NSMutableArray alloc] initWithCapacity:self.labelTextArray.count];
    
    for (NSInteger index = 0; index < self.labelTextArray.count; index++) {
        
        NSString *text = [self.labelTextArray objectAtIndex:index];
        
        UILabel *label = [UILabel new];
        
        label.font = [UIFont systemFontOfSize:self.configuration.fontSize];
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = index;
        label.text = text;
        label.textColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelDidTap:)];
        [label addGestureRecognizer:tap];
        
        [self.scrollView addSubview:label];
        [_titleLabelArray addObject:label];
        
    }
    
}


- (void)labelDidTap:(UITapGestureRecognizer *)tap {
    
    UILabel *selectLabel = (UILabel *)[tap view];
    
    self.currentSelectLabel = selectLabel;
    
    CGFloat left = selectLabel.center.x - MyWidth * 0.5f;
    CGFloat right = self.scrollView.contentSize.width - MyWidth;
    
    if (left < 0) {
        left = 0;
    }else if (left > right) {
        left = right;
    }
    
    [self.scrollView setContentOffset:CGPointMake(left, 0) animated:YES];
    
    if (self.selectAtIndex) {
        self.selectAtIndex(selectLabel.tag);
    }
}

- (void)setCurrentSelectLabel:(UILabel *)newSelectLabel {
    
    CGRect newFrame = newSelectLabel.frame;
    
    newFrame.origin.y = self.height - lineHeight;
    newFrame.size.height = lineHeight;
    
    [UIView animateWithDuration:animateDuration animations:^{
        
        _currentSelectLabel.textColor = self.configuration.labelTextColor;
        
        newSelectLabel.textColor = self.configuration.labelSelectTextColor;
        
        if (self.configuration.hasSelectAnimate) {
            
            _currentSelectLabel.transform = CGAffineTransformIdentity;

             newSelectLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        
        
        _lineView.frame = newFrame;
        
    }];
    
    _currentSelectLabel = newSelectLabel;

}

- (void)setLabelTextArray:(NSArray *)labelTextArray {
    _labelTextArray = labelTextArray;
    
    [self setupTitleLabel];
    
    [self calculateLabelFrame];
    
    [self setCurrentSelectLabel:(UILabel *)_titleLabelArray.firstObject];
}


- (void)calculateLabelFrame {
    
    _titleLabelFrameCache = [[NSMutableArray alloc] initWithCapacity:_titleLabelArray.count];

    
    for (NSInteger index = 0; index < _titleLabelArray.count; index++) {
        
        
        CGSize labelSize;
        
        if (CGSizeEqualToSize(self.configuration.labelSize, CGSizeZero)) {
            //如果没设置labelSize 计算并采用文本size
            NSString *text = [self.labelTextArray objectAtIndex:index];

            CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,self.height)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.configuration.fontSize * 1.2]} context:nil].size;
            
            labelSize = textSize;
            
        }else {
            
            labelSize = self.configuration.labelSize;
            
        }
        
        
        CGFloat label_X = self.configuration.spaceing;
        
        if (index > 0) {
            
            NSValue *lastFrame = [_titleLabelFrameCache objectAtIndex:index - 1];
            
            label_X = CGRectGetMaxX([lastFrame CGRectValue]) + self.configuration.spaceing;
            
        }
        
        
        CGRect labelFrame = CGRectMake(label_X,
                                       (self.height - labelSize.height) * 0.5,
                                       labelSize.width, labelSize.height);
        
        UILabel *currentLabel = [_titleLabelArray objectAtIndex:index];
        
        [currentLabel setFrame:labelFrame];
        
        //缓存Frame
        [_titleLabelFrameCache addObject:[NSValue valueWithCGRect:labelFrame]];
        
    }
    
    CGFloat MAX_X = CGRectGetMaxX([[_titleLabelFrameCache lastObject] CGRectValue]) + self.configuration.spaceing;
    
    self.scrollView.contentSize = CGSizeMake(MAX_X, 0);
}

- (void)updateLabelFrame {
    
    if (_titleLabelFrameCache.count == _titleLabelArray.count) {
        
        for (NSInteger index = 0; index < _titleLabelArray.count; index++) {
            
            UILabel *currentLabel = [_titleLabelArray objectAtIndex:index];
            
            [currentLabel setFrame:[[_titleLabelFrameCache objectAtIndex:index] CGRectValue]];

        }
    }else {

        [self calculateLabelFrame];
        
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    if (_titleLabelArray.count < 1) return;
    
    [self updateLabelFrame];
    
    
}

- (ListViewConfiguration *)configuration {
    if (_configuration == nil) {
        _configuration = [ListViewConfiguration defaultConfiguration];
    }
    return _configuration;
}


@end


