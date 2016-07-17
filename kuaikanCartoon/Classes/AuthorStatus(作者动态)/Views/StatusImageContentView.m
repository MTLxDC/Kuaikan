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
#import "ProgressHUD.h"

#import "AuthorStatusViewController.h"
#import "ZLPhotoPickerBrowserViewController.h"



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
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        imageView.layer.borderColor = imageView.backgroundColor.CGColor;
        imageView.layer.borderWidth = 1;
        
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _imageView = imageView;
    }
    
    return _imageView;
}

@end



@interface StatusImageContentView () <UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate>
{
    CGFloat _defaultItemSize;
    CGFloat _defaultWidth;
}

@property (nonatomic,strong) NSArray<ZLPhotoPickerBrowserPhoto *> *photos;

@property (nonatomic,strong) ZLPhotoPickerBrowserViewController *photoBrowserVc;

@end

static CGFloat margin = 5;

@implementation StatusImageContentView

- (void)setPhotoImages:(NSArray<NSURL *> *)photoImages {
    _photoImages = photoImages;
    self.photos = nil;
}

- (void)setThumbImages:(NSArray<NSURL *> *)thumbImages {
    _thumbImages = thumbImages;
    [self calculateMySizeWithImageCount:thumbImages.count];
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
    return self.thumbImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    statusImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"statusImageCell" forIndexPath:indexPath];
    
    NSURL *imageUrl = self.thumbImages[indexPath.row];
    
     cell.imageView.image = nil;
    [cell.imageView performSelector:@selector(sd_setImageWithURL:) withObject:imageUrl afterDelay:0.0f inModes:@[NSDefaultRunLoopMode]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 图片游览器
    
    ZLPhotoPickerBrowserViewController *photoBrowserVc = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    photoBrowserVc.delegate = self;
    // 数据源/delegate
    photoBrowserVc.photos = self.photos;
    // 当前选中的值
    photoBrowserVc.currentIndex = indexPath.row;
    
    // 展示控制器
    [photoBrowserVc showPickerVc:self.myViewController];

}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser saveImage:(BOOL)success atIndex:(NSInteger)index {
    
    if (success) {
        [ProgressHUD showSuccessWithStatus:@"保存图片成功" inView:pickerBrowser.view];
    }else {
        [ProgressHUD showErrorWithStatus:@"保存图片失败" inView:pickerBrowser.view];
    }

}

- (NSArray *)photos {
    
    if (!_photos) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:self.thumbImages.count];
        
        [self.photoImages enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            statusImageCell *cell = (statusImageCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            
            photo.photoURL = obj;
            photo.toView   = cell.imageView;
            photo.thumbImage = cell.imageView.image;
            
            [arr addObject:photo];
        }];
        
        _photos = [arr copy];
    }
    
    return _photos;
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




@end
