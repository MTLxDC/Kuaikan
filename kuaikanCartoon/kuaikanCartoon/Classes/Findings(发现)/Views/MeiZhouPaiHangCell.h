//
//  MeiZhouPaiHangCell.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/16.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeiZhouPaiHangCell : UITableViewCell

@property (nonatomic,copy) NSArray *topics;

@property (nonatomic,copy)  void (^itemOnClick)(NSInteger index);


@end
