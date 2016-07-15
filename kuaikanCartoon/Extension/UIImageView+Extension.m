



//
//  UIImageView+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImage+Extension.h"
#import <SDWebImageManager.h>

@implementation UIImageView (Extension)

- (void)setRoundImageWithURL:(NSString *)url placeImageName:(NSString *)placeImage {
    
    __weak UIImageView *weakSelf = self;

    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                    options:SDWebImageRetryFailed
                                                   progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       
                                                       __block __strong UIImageView *sself  = weakSelf;
                                                       sself.image = [image clipEllipseImage]; //对图片进行倒圆角
    
                                                   }];
    
}



@end
