//
//  KeyBoardManager.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "KeyBoardManager.h"

@interface KeyBoardManager ()

@property (nonatomic,strong) NSMutableDictionary<NSString *,keyboardFrameChangeCallBack> *blocks;

@end

@implementation KeyBoardManager

+ (void)frameWillChange:(keyboardFrameChangeCallBack)callback WithKey:(NSString *)key {
    [[[self share] blocks] setValue:callback forKey:key];
}

- (void)keyboardFrameChange:(NSNotification *)not {
    
    CGFloat start_Y = [not.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
    CGFloat end_Y   = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    [self.blocks enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, keyboardFrameChangeCallBack  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) obj(start_Y,end_Y);
    }];
}

+ (void)removeObserverWithKey:(NSString *)key {
    [[[self share] blocks] removeObjectForKey:key];
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
        self.blocks = [NSMutableDictionary dictionary];
    }
    return self;
}



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}




@end
