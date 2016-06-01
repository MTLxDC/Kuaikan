//
//  KeyBoardManager.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^keyboardFrameChangeCallBack)(CGFloat start_Y,CGFloat end_Y);
typedef void (^textViewContentSizeDidChange)(CGSize oldSize,CGSize newSize);

@interface KeyBoardManager : NSObject

+ (void)frameWillChange:(keyboardFrameChangeCallBack)callback;


@end
