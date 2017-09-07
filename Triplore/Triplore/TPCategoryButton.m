//
//  CategoryButton.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPCategoryButton.h"

@implementation TPCategoryButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat height = CGRectGetHeight(contentRect) / 2;
    
    CGRect rect = CGRectMake((width-30)/2, height-30, 30, 30);
    
    return rect;  
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat height = CGRectGetHeight(contentRect) / 2;
    
    CGRect rect = CGRectMake(0, height, width, height);
    
    return rect;
}

@end
