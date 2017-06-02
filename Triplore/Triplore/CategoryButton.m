//
//  CategoryButton.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "CategoryButton.h"

@implementation CategoryButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat height = CGRectGetHeight(contentRect) / 2;
    
    CGRect rect = CGRectMake((width-30)/2, height-30, 30, 30);
    
    return rect;  
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat height = CGRectGetHeight(contentRect) / 2;
    
    CGRect rect = CGRectMake(0, height, width, height);
    
    return rect;
}

@end
