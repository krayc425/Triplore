//
//  UIImageView+Decorator.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "UIImageView+Decorator.h"
#import "UIImage+Extend.h"

@implementation UIImageView (Decorator)

- (void)decorateWithGreen{
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NOTE_IMAGE_GREEN_1"]];
    [leftImg setFrame:CGRectMake(-2, CGRectGetHeight(self.frame) - 40 + 2, 40, 40)];
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NOTE_IMAGE_GREEN_2"]];
    [rightImg setFrame:CGRectMake(CGRectGetWidth(self.frame) - 40 + 2, -2, 40, 40)];
    [self addSubview:leftImg];
    [self addSubview:rightImg];
}

- (void)decorateWithBrown{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = CGRectGetWidth(self.frame) - 20;
    CGFloat height = CGRectGetHeight(self.frame) / CGRectGetWidth(self.frame) * width;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+20, height+50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    UIImageView *tmpView = [[UIImageView alloc] initWithImage:self.image];
    [tmpView setFrame:CGRectMake(10, 10, width, height)];
    tmpView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:tmpView];
    self.image = [UIImage new];
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2.0;
    self.layer.shadowOpacity = 0.3;
}

@end
