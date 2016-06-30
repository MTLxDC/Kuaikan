//
//  DCPicScrollView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//

#import "DCPicScrollView.h"
#import "DCPicItem.h"


@interface DCPicScrollView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,weak) UICollectionView *cycleScrollView;

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,weak) UIView<pageControlProtocol> *page;

@property (nonatomic,strong) DCPicScrollViewConfiguration *configuration;

@property (nonatomic) CGRect pageFrame;

@property (nonatomic) NSUInteger itemCount;

@property (nonatomic) NSUInteger currentItem;

@property (nonatomic) CGFloat maxOffsetX;

@end

static NSString * const reuseIdentifier = @"DCPicItem";

static const NSUInteger totalItem = 1000;

#define MyWidth  self.bounds.size.width
#define MyHeight self.bounds.size.height

@implementation DCPicScrollView

#pragma mark Construction method 构造方法

+ (instancetype)picScrollViewWithFrame:(CGRect)frame withConfiguration:(DCPicScrollViewConfiguration *)configuration withDataSource:(id<DCPicScrollViewDataSource>)dataSource{
    return [[[self class] alloc] initWithFrame:frame withConfiguration:configuration withDataSource:dataSource];
}


+ (instancetype)picScrollViewWithFrame:(CGRect)frame withDataSource:(id<DCPicScrollViewDataSource>)dataSource {
    return [[[self class] alloc] initWithFrame:frame withDataSource:dataSource];
}


- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<DCPicScrollViewDataSource>)dataSource {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.dataSource = dataSource;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withConfiguration:(DCPicScrollViewConfiguration *)configuration withDataSource:(id<DCPicScrollViewDataSource>)dataSource{
   self = [super initWithFrame:frame];
    
    if (self) {
        
        self.configuration = configuration;
        self.dataSource = dataSource;
        
    }
    
    return self;
}


#pragma mark Timer 定时器

- (void)setupTimerIfNeed {
    
    if(self.itemCount > 1 && self.configuration.needAutoScroll && self.timer == nil) {
    
        __weak DCPicScrollView * weakSelf = self;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.configuration.timeInterval block:^{
            
            NSUInteger nextItem = weakSelf.currentItem + 1;
            
            [weakSelf.cycleScrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                             atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            
        } repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    
    if (!self.timer) return;
    
    [self.timer invalidate];
    _timer = nil;
}

#pragma mark UICollectionViewDelegate 代理

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer pause];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.timer begin];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollToCenterIfNeed];
    self.page.currentPage = self.currentIndex;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(picScrollView:selectItem:atIndex:)]) {
        [self.delegate picScrollView:self selectItem:(DCPicItem *)[collectionView cellForItemAtIndexPath:indexPath] atIndex:indexPath.row % self.itemCount];
    }
}
#pragma mark UICollectionViewDataSource 数据源

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.itemCount * totalItem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    DCPicItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    item.configuration = self.configuration.itemConfiguration;
    
    NSInteger currentIndex = indexPath.row % self.itemCount;
    
    [self.dataSource picScrollView:self needUpdateItem:item atIndex:currentIndex];
    
    return item;
}

#pragma mark Encapsulation methods 封装方法

/* 检测越界,如果越界滚到中间 */

- (void)scrollToCenterIfNeed {
    
    CGFloat offsetX = self.cycleScrollView.contentOffset.x;
    
    if (offsetX > 1 || offsetX < self.maxOffsetX) return;
    
    NSInteger centerIndex = (self.itemCount * totalItem) * 0.5;
    
    NSIndexPath *scorllTo = [NSIndexPath indexPathForItem:centerIndex inSection:0];
    
    [self.cycleScrollView scrollToItemAtIndexPath:scorllTo atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}

/* 计算根据PageContolAlignment枚举来计算frame */

- (void)calculatePageFrame {
    
    CGFloat xSpaceing = MyWidth * 0.02;
    
    CGSize pageSize = [self.page sizeForNumberOfPages:self.itemCount];
    
    CGFloat x,y;
    
    UIEdgeInsets edge = self.configuration.pageEdgeInsets;
    
    y = MyHeight - pageSize.height + (edge.bottom - edge.top);
    
    if (self.configuration.pageAlignment == PageContolAlignmentCenter) {
        x = (MyWidth - pageSize.width) * 0.5;
    }else {
        x = MyWidth - pageSize.width - xSpaceing + (edge.left - edge.right);
    }
    
    self.pageFrame = CGRectMake(x, y, pageSize.width, pageSize.height);
    
    [self.page setFrame:self.pageFrame];
}

- (void)reloadData {
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInPicScrollView:)],
             @"The datasoure must be implemented numberOfItemsInPicScrollView: method");
    
    NSAssert([self.dataSource respondsToSelector:@selector(picScrollView:needUpdateItem:atIndex:)],@"The datasoure must be implemented picScrollView:needUpdateItem:atIndex: method");
    
    self.itemCount = [self.dataSource numberOfItemsInPicScrollView:self];   //获取item的个数

    [self updatePage];
    
    [self.cycleScrollView reloadData];
    
    [self setupTimerIfNeed];
    
    self.maxOffsetX = self.cycleScrollView.contentSize.width - self.bounds.size.width * 2;
}

- (void)updatePage {
    
    self.page.numberOfPages = self.itemCount;
    
    self.page.currentPage   = 0;
    
    [self calculatePageFrame]; //计算PageControlFrame
    
}

#pragma mark The UIView Life cycle 生命周期

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cycleScrollView.frame = self.bounds;
    self.flowLayout.itemSize = self.bounds.size;

    self.page.frame = self.pageFrame;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self removeTimer];
    }
}

#pragma mark 计算型属性

- (NSUInteger)currentItem {
    return lrintf(self.cycleScrollView.contentOffset.x/self.flowLayout.itemSize.width);
}

- (NSUInteger)currentIndex {
    return self.currentItem % self.itemCount;
}

- (void)setDataSource:(id<DCPicScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

#pragma mark lazyLoad  懒加载

- (UICollectionView *)cycleScrollView {
    if (!_cycleScrollView) {
        
        UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        
        [cv registerClass:[DCPicItem class] forCellWithReuseIdentifier:reuseIdentifier];
        
        cv.pagingEnabled = YES;
        cv.dataSource = self;
        cv.delegate = self;
        cv.scrollsToTop = NO;
        cv.backgroundColor = [UIColor whiteColor];
        cv.showsVerticalScrollIndicator = NO;
        cv.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:cv];
        
        [self addSubview:self.page];
        
        _cycleScrollView = cv;
    }
    return _cycleScrollView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 0.0f;
        layout.minimumLineSpacing = 0.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _flowLayout = layout;
    }
    
    return _flowLayout;
}

- (UIView<pageControlProtocol> *)page {
    if (!_page) {
        
        _page = self.configuration.page;
        _page.hidesForSinglePage = YES;
        
    }
    return _page;
}

- (DCPicScrollViewConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [DCPicScrollViewConfiguration defaultConfiguration];
    }
    return _configuration;
}


@end
