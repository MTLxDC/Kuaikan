



//
//  UIImageView+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/8.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImage+Extension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Extension)

- (void)setRoundImageWithURL:(NSString *)url placeImageName:(NSString *)placeImage {
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    
    UIImage *clipImageCache = [cache imageFromDiskCacheForKey:url];  //是否有缓存倒角后的图片,如果有直接取出,方法结束
    
    if (clipImageCache) {
        self.image = clipImageCache;
        return;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:placeImage]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                                [cache removeImageForKey:url];  //移除未倒角的图片
                                
                                CGFloat radius = MIN(image.size.width, image.size.height) * 0.5;
                                
                                UIImage *roundImage = [image clipImageWithRadius:radius]; //对图片进行倒圆角
                                
                                self.image = roundImage;
                                
                                [cache storeImage:roundImage forKey:url];   //缓存倒圆角后的图片
                                
                            }];
    
}



@end
