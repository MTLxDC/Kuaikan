//
//  StatusImageContentView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusImageContentView : UICollectionView

@property (nonatomic,copy) NSArray *imageUrls;

+ (instancetype)makeStatusImageContentView ;

@end
