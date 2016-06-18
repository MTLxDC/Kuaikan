//
//  CommonMacro.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//



#define weakself(self)  __weak __typeof(self) weakSelf = self

// iOS系统版本

#define IOSBaseVersion9     9.0
#define IOSBaseVersion8     8.0
#define IOSBaseVersion7     7.0
#define IOSBaseVersion6     6.0

#define IOSCurrentBaseVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define iOS9Later (IOSCurrentBaseVersion >= IOSBaseVersion9)
#define iOS8Later (IOSCurrentBaseVersion >= IOSBaseVersion8)
#define iOS7Later (IOSCurrentBaseVersion >= IOSBaseVersion7)
#define iOS6Later (IOSCurrentBaseVersion >= IOSBaseVersion6)

#define MainScreen [UIScreen mainScreen]

#define SCREEN_SCALE    [MainScreen scale]
#define SCREEN_BOUNDS   [MainScreen bounds]
#define SCREEN_SIZE     [MainScreen bounds].size
#define SCREEN_WIDTH    [MainScreen bounds].size.width
#define SCREEN_HEIGHT   [MainScreen bounds].size.height

#define SINGLE_LINE_WIDTH           (1 / SCREEN_SCALE)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / SCREEN_SCALE) / 2)

#define navHeight  (iOS7Later ? 64.0 : 44.0)
#define bottomBarHeight 44.0

#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isRetina (SCREEN_SCALE >= 2.0)

#define IsiPhone4   (IsiPhone && ScreenMaxLength < 568.0)
#define IsiPhone5   (IsiPhone && ScreenMaxLength == 568.0)
#define IsiPhone6   (IsiPhone && ScreenMaxLength == 667.0)
#define IsiPhone6P  (IsiPhone && ScreenMaxLength == 736.0)


// 日志输出
#ifdef DEBUG
#define DEBUG_Log(...) NSLog(__VA_ARGS__)
#else
#define DEBUG_Log(...)
#endif


// 消息通知
#define RegisterNotify(_name, _selector)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:nil];

#define RemoveNofify            \
[[NSNotificationCenter defaultCenter] removeObserver:self];

#define SendNotify(_name, _object)  \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object];

// 设置颜色值

#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define subjectColor RGB(254,208,9) //主题颜色

#define colorWithImageName(name) [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:name]]

#define line_Darkgray colorWithImageName(@"line_#aeaeae_0x0_")
#define line_Lightgray colorWithImageName(@"line_#e1e1e1_0x0_")

#define colorWithWhite(value) [[UIColor alloc] initWithWhite:value alpha:1]

#define placeImage_comic [UIImage imageNamed:@"ic_new_comic_placeholder_s_355x149_"]



