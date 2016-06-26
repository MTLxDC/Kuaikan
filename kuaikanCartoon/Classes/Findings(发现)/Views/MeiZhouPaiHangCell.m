//
//  MeiZhouPaiHangCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MeiZhouPaiHangCell.h"
#import "MeiZhouPaiHangItem.h"
#import "topicModel.h"
#import "UIView+Extension.h"
#import "CommonMacro.h"
#import "WordsDetailViewController.h"

@interface MeiZhouPaiHangCell () <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *items;

@property (nonatomic,strong) NSArray *spaceingLines;

@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation MeiZhouPaiHangCell

- (void)setTopics:(NSArray *)topics {
    _topics = topics;
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:topics.count + 1];

    for (NSInteger index = 0; index < topics.count; index++) {
        
        topicModel *model = topics[index];
        
        MeiZhouPaiHangItem *item = [MeiZhouPaiHangItem makeMeiZhouPaiHangItem];
        
        item.model = model;
        item.rankingNumber = index + 1;
        item.tag = index;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [item addGestureRecognizer:tap];
        
        [self.scrollView addSubview:item];
        
        [items addObject:item];
    }
    
    self.items = [items copy];
}

- (void)tap:(UITapGestureRecognizer *)tap {
   
    MeiZhouPaiHangItem *item = (MeiZhouPaiHangItem *)[tap view];
    
    if (self.itemOnClick) {
        self.itemOnClick(item.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.items.count < 1) return;
    
    CGFloat spaceing  = 8;
    
    self.scrollView.frame = CGRectMake(spaceing, spaceing,
                                       self.contentView.width - spaceing,
                                       self.contentView.height - spaceing * 2);
    
    CGFloat itemWidth  = self.scrollView.width;
    CGFloat itemHeight = self.scrollView.height * 0.33 + 1;
    
    NSInteger itemCount = self.items.count;
    NSInteger sectionCount = lround(itemCount/3) + 1;
    
    self.scrollView.contentSize = CGSizeMake(sectionCount * itemWidth,0);
    
    CGFloat itemX = 0;
    CGFloat itemY = 0;

    NSInteger index_X = 0;
    NSInteger index_Y = 0;
    
    for (NSInteger index = 0; index < self.items.count; index++) {
        
        itemX = index_X * itemWidth + spaceing;
        itemY = index_Y * itemHeight;
        
        MeiZhouPaiHangItem *item = [self.items objectAtIndex:index];
        
        [item setFrame:CGRectMake(itemX, itemY, itemWidth, itemHeight)];
        
        index_Y++;
        
        if (index_Y == 2) item.hideLine = YES;
        
        if (index_Y >= 3) {
            index_X++;
            index_Y = 0;
        }
    }
    
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        UIScrollView *sc = [UIScrollView new];
        
        sc.pagingEnabled = YES;
        sc.showsHorizontalScrollIndicator = NO;
        sc.showsVerticalScrollIndicator = NO;

        [self.contentView addSubview:sc];
        
        
        _scrollView = sc;
    }
    
    return _scrollView;
}


@end
