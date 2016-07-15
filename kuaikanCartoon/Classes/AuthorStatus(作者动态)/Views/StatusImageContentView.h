//
//  StatusImageContentView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/2.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusImageContentView : UICollectionView

@property (nonatomic,copy)   NSArray<NSString *> *photoImages; //原图

@property (nonatomic,copy)   NSArray<NSString *> *thumbImages; //缩略图

+ (instancetype)makeStatusImageContentView ;

@end
