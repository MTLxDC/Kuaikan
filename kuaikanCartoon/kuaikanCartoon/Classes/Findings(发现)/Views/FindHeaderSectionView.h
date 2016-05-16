//
//  FindHeaderSectionView.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/15.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindHeaderSectionView : UIView

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) void (^moreOnClick)();

@end
