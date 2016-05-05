//
//  Color.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//


#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define subjectColor RGB(254,208,9)


#define colorWithImage(name) [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:name]]

#define line_Darkgray colorWithImage(@"line_#aeaeae_0x0_")
#define line_Lightgray colorWithImage(@"line_#e1e1e1_0x0_")

#define White(value) [[UIColor alloc] initWithWhite:value alpha:1]

