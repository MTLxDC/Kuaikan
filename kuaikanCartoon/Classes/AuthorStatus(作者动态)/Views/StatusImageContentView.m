//
//  StatusImageContentView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import "StatusImageContentView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UIView+Extension.h"
#import "CommonMacro.h"

@interface statusImageCell : UICollectionViewCell
{
    UIImageView *_imageView;
}

@property (nonatomic,weak,readonly) UIImageView *imageView;

@end

@implementation statusImageCell

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _imageView = imageView;
    }
    
    return _imageView;
}

@end

@interface StatusImageContentView () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    CGFloat _defaultItemSize;
    CGFloat _defaultWidth;
}

@property (nonatomic,weak) UITableView *myTableView;

@end

static CGFloat margin = 5;

@implementation StatusImageContentView

- (void)setImageUrls:(NSArray *)imageUrls {
    _imageUrls = imageUrls;
    [self calculateMySizeWithImageCount:imageUrls.count];
    [self reloadData];
}

+ (instancetype)makeStatusImageContentView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    return [[[self class] alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = NO;
    
        _defaultWidth    =  SCREEN_WIDTH - SPACEING * 2;
        _defaultItemSize = (_defaultWidth - margin * 2)/3 - 1;
        
        [self registerClass:[statusImageCell class] forCellWithReuseIdentifier:@"statusImageCell"];
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    statusImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"statusImageCell" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[indexPath.row]]];
    
    return cell;
}


- (void)calculateMySizeWithImageCount:(NSInteger)imageCount {
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    CGFloat newWidth  = 0;
    CGFloat newHeight = 0;
    
    if (imageCount == 0) {
        layout.itemSize = CGSizeZero;
    }

    if (imageCount == 1) {
        
        newWidth  = _defaultWidth * 0.66;
        newHeight = newWidth;
        
        layout.itemSize = CGSizeMake(newWidth, newHeight);
        
    }else {
        layout.itemSize = CGSizeMake(_defaultItemSize,_defaultItemSize);
    }
    
    if (imageCount > 1 && imageCount <= 3) {
        newWidth  = _defaultWidth;
        newHeight = _defaultItemSize;
    }
    
    if (imageCount == 4) {
        CGFloat newSize = _defaultItemSize * 2 + margin;
        newWidth  = newSize + margin;
        newHeight = newSize;
    }
    
    if (imageCount > 4) {
        
        NSInteger row = ((imageCount - 1) / 3 + 1);
        
        newWidth  = _defaultWidth;
        newHeight = _defaultItemSize * row + margin * (row - 1);

    }

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(newHeight));
        make.width.equalTo(@(newWidth));
    }];
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [self findResponderWithClass:[UITableView class]];
    }
    return _myTableView;
}



@end
