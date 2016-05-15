//
//  NSTimer+Control.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Control)

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats;

- (void)begin;
- (void)pause;


@end
