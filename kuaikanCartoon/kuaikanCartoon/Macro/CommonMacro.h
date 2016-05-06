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




// 日志输出
#ifdef DEBUG
#define DEBUG_Log(...) NSLog(__VA_ARGS__)
#else
#define DEBUG_Log(...)
#endif