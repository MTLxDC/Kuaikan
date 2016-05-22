//
//  SearchHistoryCell.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SearchHistoryCell.h"
#import <Masonry.h>

static CGFloat spaceing = 8;

@interface SearchHistoryCell ()

@property (nonatomic,weak) UILabel *historyInfo;

@end

@implementation SearchHistoryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}

- (void)setHistory:(NSString *)history {
    _history = history;
    self.historyInfo.text = history;
}

- (void)setupUI {
    
    UIImageView *timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search_time_14x14_"]];
    
    [self.contentView addSubview:timeIcon];
    
    [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(spaceing);
        make.width.height.equalTo(@14);
    }];
    
    UIButton *deleteBtn = [UIButton new];
    
    [deleteBtn setImage:[UIImage imageNamed:@"ic_search_delete_normal_11x11_"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"ic_search_delete_pressed_11x11_"] forState:UIControlStateHighlighted];
    
    [deleteBtn addTarget:self action:@selector(deleteItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-spaceing);
        make.width.height.equalTo(@14);
    }];
    
    UILabel *historyInfo = [UILabel new];
    
    [self.contentView addSubview:historyInfo];
    
    historyInfo.font = [UIFont systemFontOfSize:14];
    historyInfo.textColor = [UIColor lightGrayColor];
    
    [historyInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(timeIcon.mas_right).offset(spaceing);
        make.right.equalTo(deleteBtn).offset(-spaceing);
        make.height.equalTo(@14);
    }];
    
    self.historyInfo = historyInfo;
}

- (void)deleteItem {
    if (self.deleteBtnOnClick) {
        self.deleteBtnOnClick(self);
    }
}

@end
