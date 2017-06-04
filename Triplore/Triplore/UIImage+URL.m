//
//  UIImage+URL.m
//  Triplore
//
//  Created by Sorumi on 17/6/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "UIImage+URL.h"

@implementation UIImage (URL)

+ (UIImage *)imageWithUrl:(NSString *)url {
    NSURL *imageUrl = [NSURL URLWithString:url];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    return image;
}

@end
