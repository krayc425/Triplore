//
//  UIImage+Extend.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

- (UIImage *)changeImageSizeWithOriginalImage:(UIImage*)image percent:(float)percent;

- (UIImage *)getSubImage:(CGRect)rect;

@end
