//
//  NSTimer+Control.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/13.
//  Copyright © 2016年 name. All rights reserved.
//
#import <objc/runtime.h>
#import "NSTimer+Control.h"

@implementation NSTimer (Control)



+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(block_blockInvoke:) userInfo:[block copy] repeats:repeats];
}



+ (void)block_blockInvoke:(NSTimer *)timer {
       if (!timer.isValid) return;
       void (^block)() = timer.userInfo;
    
        if (block) block();
}


- (void)begin {
    self.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.timeInterval];
}

- (void)pause {
    self.fireDate = [NSDate distantFuture];
}



@end
