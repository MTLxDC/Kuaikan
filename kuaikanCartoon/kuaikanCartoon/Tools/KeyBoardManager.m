//
//  KeyBoardManager.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "KeyBoardManager.h"

@interface KeyBoardManager ()

@property (nonatomic,strong) NSMutableArray<keyboardFrameChangeCallBack> *blocks;

@end

@implementation KeyBoardManager

+ (void)frameWillChange:(keyboardFrameChangeCallBack)callback {
    [[[[self class] share] blocks] addObject:callback];
}

- (void)keyboardFrameChange:(NSNotification *)not {
    
    CGFloat start_Y = [not.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
    CGFloat end_Y   = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
   
    [self.blocks enumerateObjectsUsingBlock:^(keyboardFrameChangeCallBack  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) obj(start_Y,end_Y);
    }];
}




+ (instancetype)share
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KeyBoardManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.blocks = [NSMutableArray array];
    }
    return self;
}



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}




@end
