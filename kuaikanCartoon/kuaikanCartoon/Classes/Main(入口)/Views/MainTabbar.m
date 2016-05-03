//
//  MainTabbar.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "MainTabbar.h"


@interface MainTabbarItem : UIButton



@end

@implementation MainTabbarItem

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end

@interface MainTabbar ()

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,weak) UIButton *lastBtn;

@property (nonatomic,weak) UIView *line;

@property (nonatomic,weak) UIImageView *bgView;

@end

@implementation MainTabbar

- (void)btnClick:(UIButton *)btn {

    if (self.lastBtn != btn) {
        self.lastBtn.selected = NO;
        self.lastBtn = btn;
    }
    
    btn.selected = YES;
    
    if (self.selectAtIndex) {
        self.selectAtIndex(btn,btn.tag);
    }
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    if (self.items.count < 1) {
        return;
    }
    
    NSInteger count = self.items.count;
    
    CGFloat spacing = self.bounds.size.width/count;
    
    CGFloat x = spacing * 0.5 - 15;
    CGFloat y = self.bounds.size.height * 0.5 - 15;
    
    for (NSInteger index = 0; index < count; index++) {
        
        UIButton *item = self.items[index];
        
        [item setFrame:CGRectMake(x + index * spacing, y, 30, 30)];
        
    }
    
}

- (void)addItemWithImageNames:(NSArray *)names {
    for (NSInteger index = 0; index < names.count; index++) {
        [self addItemWithImageName:names[index]];
    }
    self.selectItem = 0;
}


- (void)addItemWithImageName:(NSString *)name {
    
    NSString *normal = [NSString stringWithFormat:@"ic_tabbar_%@_normal_30x30_",name];
    
    NSString *pressed = [NSString stringWithFormat:@"ic_tabbar_%@_pressed_30x30_",name];
    
    UIImage *image = [UIImage imageNamed:normal];
    
    UIImage *selectedImage = [UIImage imageNamed:pressed];
    
    
    MainTabbarItem *item = [MainTabbarItem new];

    [item setBackgroundImage:image forState:UIControlStateNormal];
    [item setBackgroundImage:selectedImage forState:UIControlStateSelected];
    
    [item setTag:self.items.count];
    [item addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.items addObject:item];
    [self addSubview:item];

    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bg = [UIImageView new];
        
        self.bgView = bg;
        
        self.bgView.image = [UIImage imageNamed:@"Tabbar-Bg_2x45_"];
        [self addSubview:self.bgView];
    }
    return self;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

-(NSInteger)cuurentSelectIndex {
    return [self.items indexOfObject:self.lastBtn];
}

- (void)setSelectItem:(NSInteger)selectItem {
    if (selectItem < self.items.count) {
        _selectItem = selectItem;
        [self btnClick:self.items[selectItem]];
    }
}


@end
