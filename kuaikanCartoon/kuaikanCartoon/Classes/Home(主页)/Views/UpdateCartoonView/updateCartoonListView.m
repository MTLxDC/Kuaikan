//
//  updateCartoonListView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import "updateCartoonListView.h"
#import "SummaryListItem.h"
#import "DateManager.h"

@interface updateCartoonListView ()<UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSArray *requestUrlArray;

@end

@implementation updateCartoonListView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:self.flowLayout];
    if (self) {
        
        self.flowLayout.itemSize = self.bounds.size;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    
    self.dataSource = self;
    self.pagingEnabled = YES;
    self.bounces = NO;
    
    [self registerClass:[SummaryListItem class] forCellWithReuseIdentifier:@"SummaryListItem"];
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.requestUrlArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SummaryListItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"SummaryListItem" forIndexPath:indexPath];
    item.urlString = self.requestUrlArray[indexPath.item];
    
    return item;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.flowLayout.itemSize = self.bounds.size;
    
}


- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}



- (NSArray *)requestUrlArray {
    if (!_requestUrlArray) {
        
      DateManager *date = [DateManager share];
        
        NSString *formatUrl = @"http://api.kuaikanmanhua.com/v1/daily/comic_lists/%@?since=0";
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:7];

        for (NSInteger index = 1; index < 8; index++) {
            
            NSString *timeStamp = [date timeStampWithDate:[date dateByAddingDays:index - 7]];
            NSString *newUrl = [NSString stringWithFormat:formatUrl,timeStamp];
            
            [array addObject:newUrl];
        }
        
        _requestUrlArray = [array copy];
        
        
    }
    return _requestUrlArray;
}
@end
