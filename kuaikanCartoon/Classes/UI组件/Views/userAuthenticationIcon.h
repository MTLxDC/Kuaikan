//
//  userAuthenticationIcon.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface userAuthenticationIcon : UIView

@property (nonatomic,assign) BOOL hasAuthentication;

@property (nonatomic,assign) CGFloat authenticatIconSize;


- (void)updateIconWithImageUrl:(NSString *)imageUrl;

@end
