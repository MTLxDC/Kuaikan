//
//  CommonMacro.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#define SCREEN_BOUNDS   [[UIScreen mainScreen] bounds]
#define SCREEN_SIZE     [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define navHeight 64.0f
#define bottomBarHeight 44.0f

#define weakself(self)  __weak __typeof(self) weakSelf = self

#define iOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS6Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad   ? YES : NO)
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO)
#define isRetina ([[UIScreen mainScreen] scale] > 1 ? YES : NO)


// 日志输出
#ifdef DEBUG
#define DEBUG_Log(...) NSLog(__VA_ARGS__)
#else
#define DEBUG_Log(...)
#endif