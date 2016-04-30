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

#define navHeight 64.0f

#define weakself(self)  __weak __typeof(self) weakSelf = self


#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define subjectColor RGB(254,208,9)