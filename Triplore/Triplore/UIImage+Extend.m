//
//  UIImage+Extend.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

//按比例改变图片大小
- (UIImage *)changeImageSizeWithOriginalImage:(UIImage*)image percent:(float)percent{
    UIImage *changedImage=nil;
    float iwidth=image.size.width*percent;
    float iheight=image.size.height*percent;
    if (image.size.width != iwidth && image.size.height != iheight){
        CGSize itemSize = CGSizeMake(iwidth, iheight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        changedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        changedImage = image;
    }
    
    return changedImage;
}

//截取部分图像
- (UIImage *)getSubImage:(CGRect)rect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, YES, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
