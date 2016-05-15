//
//  DCPicItemConfiguration.h
//  DCWebPicScrollView
//
//  Created by dengchen on 16/5/14.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPicItemConfiguration : NSObject

//imageViewSetting

@property (nonatomic,assign) UIViewContentMode contentMode;

@property (nonatomic,strong) UIImage *placeImage;


//titleLableSetting

@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,strong) UIFont  *textFont;


//bottomViewSetting

@property (nonatomic,strong) UIColor *bgColor;

@property (nonatomic,strong) UIImage *bgImage;

@property (nonatomic,assign) BOOL showBottomView;

@property (nonatomic,assign) CGFloat bottomViewHeight;


+ (instancetype)defaultConfiguration;
+ (instancetype)hasTitleViewConfiguration;

@end
