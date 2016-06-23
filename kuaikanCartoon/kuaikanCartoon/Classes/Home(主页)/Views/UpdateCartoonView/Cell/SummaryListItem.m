//
//  SummaryListItem.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/29.
//  Copyright © 2016年 name. All rights reserved.
//

#import "SummaryListItem.h"
#import "UIView+Extension.h"
/* SummaryListItem  */

@interface SummaryListItem ()

@property (nonatomic,weak) WordsListView *slv;

@end

@implementation SummaryListItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        WordsListView *slv = [[WordsListView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        [self.contentView addSubview:slv];
        
        self.slv = slv;
                
        self.backgroundColor = slv.backgroundColor;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.slv.frame = self.bounds;
    
}

- (void)setUrlString:(NSString *)urlString {
    self.slv.urlString = urlString;
}


@end