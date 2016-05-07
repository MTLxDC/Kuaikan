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
    
    
    return lc;
}

- (void)setMonitorScrollView:(UIScrollView *)monitorScrollView {
    _monitorScrollView = monitorScrollView;
    if (self.MonitorScrollViewItemWidth < 1) {
        [self setMonitorScrollViewItemWidth:[UIScreen mainScreen].bounds.size.width];
        if (self.labelWidth < 1) {
            self.labelWidth = 50;
        }
    }
}



@end

#define MyWidth self.bounds.size.width

static const CGFloat animateDuration = 0.3f;

static const CGFloat lineHeight = 3.0f;

@interface ListView ()

@property (nonatomic,strong) ListViewConfiguration *configuration;

@property (nonatomic,weak) UIScrollView *scrollView;

@property (nonatomic,assign) CGFloat itemScale;

@property (nonatomic,assign) CGFloat itemWidth;


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
        
        if (self.configuration.monitorScrollView) {
            [self.configuration.monitorScrollView addObserver:self forKeyPath:offsetKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
            self.itemScale = (self.configuration.labelWidth + self.configuration.spaceing)/self.configuration.MonitorScrollViewItemWidth;
            self.itemWidth = self.configuration.labelWidth + self.configuration.spaceing;
        }
        
        
        [self setupSubviews];
        
        if (textArray.count > 0) {
            self.labelTextArray = textArray;
        }
        
    }
    
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:offsetKeyPath context:(__bridge void * _Nullable)(self)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == (__bridge void *)self) {
        
        CGFloat offsetX = [change[NSKeyValueChangeNewKey] CGPointValue].x * self.itemScale +self.configuration.spaceing;
        
        [self scrollWithOffsetX:offsetX];
        
        
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
    
    CGFloat line_h = SINGLE_LINE_WIDTH;
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [[UIColor alloc] initWithWhite:0.8 alpha:1].CGColor;
    line.frame = CGRectMake(0,self.height - line_h,self.width,line_h);
    
    [self.layer addSublayer:line];
}


- (void)setupLineView {
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,self.height - lineHeight,0, lineHeight)];
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
    
    [self selectItem:selectLabel];
    

}

- (void)selectItem:(UILabel *)selectLabel {
//    
//    CGRect newFrame = selectLabel.frame;
//    
//    newFrame.origin.x = newFrame.origin.x + self.configuration.spaceing;
//    newFrame.origin.y = self.height - lineHeight;
//    newFrame.size.height = lineHeight;
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        _lineView.frame = newFrame;
//    }];
    

    NSLog(@"%@",NSStringFromCGRect(_lineView.frame));

    
    [self scrollWithOffsetX:selectLabel.center.x];
    
    if (self.configuration.monitorScrollView) {
        CGFloat offsetX = self.configuration.MonitorScrollViewItemWidth * selectLabel.tag;
        [self.configuration.monitorScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    if (self.selectAtIndex) {
        self.selectAtIndex(selectLabel.tag);
    }
    
}

- (void)scrollWithOffsetX:(CGFloat)x {
    
    [_lineView setX:x];

    _currentIndex = round(x/(self.itemWidth));
    
    if (_currentIndex >= _titleLabelArray.count) {
        _currentIndex--;
    }
    
    [self setCurrentSelectLabel:_titleLabelArray[_currentIndex]];
    
    CGFloat left = x - MyWidth * 0.5f;
    CGFloat right = self.scrollView.contentSize.width - MyWidth;
    
    if (left < 0) {
        left = 0;
    }else if (left > right) {
        left = right;
    }
    
    [self.scrollView setContentOffset:CGPointMake(left, 0) animated:YES];
}

- (void)setCurrentSelectLabel:(UILabel *)newSelectLabel {

    if (_currentSelectLabel == newSelectLabel) {
        return;
    }
    
    [UIView animateWithDuration:animateDuration animations:^{
        
        _currentSelectLabel.textColor = self.configuration.labelTextColor;
        
        newSelectLabel.textColor = self.configuration.labelSelectTextColor;
        
        if (self.configuration.hasSelectAnimate) {
            
            _currentSelectLabel.transform = CGAffineTransformIdentity;
            
            newSelectLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        
    }];
    
    _currentSelectLabel = newSelectLabel;
    
}

- (void)setLabelTextArray:(NSArray *)labelTextArray {
    _labelTextArray = labelTextArray;
    
    [self setupTitleLabel];
    
    [self calculateLabelFrame];
    
    [self setCurrentSelectLabel:(UILabel *)_titleLabelArray.firstObject];
    
        if (self.itemWidth > 1) {
            [_lineView setWidth:self.configuration.labelWidth];
            [_lineView setX:self.configuration.spaceing];
        }else {
            CGRect firstFrame = [_titleLabelFrameCache.firstObject CGRectValue];
            [_lineView setWidth:firstFrame.size.width];
            [_lineView setX:firstFrame.origin.x + self.configuration.spaceing];
        }
    

}


- (void)calculateLabelFrame {
    
    _titleLabelFrameCache = [[NSMutableArray alloc] initWithCapacity:_titleLabelArray.count];
    
    
    for (NSInteger index = 0; index < _titleLabelArray.count; index++) {
        
        
        CGSize labelSize;
        
        if (self.configuration.labelWidth < 1) {
            //如果没设置labelSize 计算并采用文本size
            NSString *text = [self.labelTextArray objectAtIndex:index];
            
            CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,self.height)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.configuration.fontSize * 1.2]} context:nil].size;
            
            labelSize = textSize;
            
        }else {
            
            labelSize = CGSizeMake(self.configuration.labelWidth, self.height);
            
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
    
    
        for (NSInteger index = 0; index < _titleLabelArray.count; index++) {
            
            UILabel *currentLabel = [_titleLabelArray objectAtIndex:index];
            
            [currentLabel setFrame:[[_titleLabelFrameCache objectAtIndex:index] CGRectValue]];
            
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


