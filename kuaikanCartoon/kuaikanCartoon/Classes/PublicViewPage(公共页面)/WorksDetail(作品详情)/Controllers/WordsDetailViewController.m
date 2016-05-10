//
//  WordsDetailViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "WordsDetailViewController.h"
#import "wordsDetailModel.h"
#import "CommonMacro.h"

@interface WordsDetailViewController ()

@property (nonatomic,strong) wordsDetailModel *wordsModel;

@end

@implementation WordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

}

- (void)setupNavBar {

}

- (void)requestData {
    
    NSString *url = [NSString stringWithFormat:@"http://api.kuaikanmanhua.com/v1/topics/%@?sort=0",self.wordsID];
    
    weakself(self);
    
    [wordsDetailModel requestModelDataWithUrlString:url complish:^(id res) {
        
        
            weakSelf.wordsModel = res;
            
        
    } useCache:YES];
    
}

@end
