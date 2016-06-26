//
//  CustomSearchBar.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/21.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSearchBar;

@protocol CustomSearchBarDelegate <NSObject>

- (void)customSearchBar:(CustomSearchBar *)searchBar textDidChange:(NSString *)text;

- (void)customSearchBarNeedDisMiss:(CustomSearchBar *)searchBar;

- (void)customSearchBarDidBeginEditing:(CustomSearchBar *)searchBar;

@end

@interface CustomSearchBar : UIView

@property (nonatomic,weak) id<CustomSearchBarDelegate> delegate;


- (void)changeSearchText:(NSString *)text;

+ (instancetype)makeCustomSearchBar;

@end
