//
//  UIImage+Extend.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

//按比例改变图片大小
-(UIImage*)changeImageSizeWithOriginalImage:(UIImage*)image percent:(float)percent;
//圆形
-(UIImage*)circleImage:(UIImage*)image;
//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect;

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size;

-(UIImage *)rotateImage:(UIImage *)aImage with:(UIImageOrientation)theorient;

-(UIImage *)fixOrientation:(UIImage *)aImage;

@end
