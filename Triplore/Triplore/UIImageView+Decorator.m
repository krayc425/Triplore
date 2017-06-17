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
    [leftImg setFrame:CGRectMake(-5, CGRectGetHeight(self.frame) - 40 + 5, 40, 40)];
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NOTE_IMAGE_GREEN_2"]];
    [rightImg setFrame:CGRectMake(CGRectGetWidth(self.frame) - 40 + 5, -5, 40, 40)];
    [self addSubview:leftImg];
    [self addSubview:rightImg];
}

- (void)decorateWithBrown{
    self.backgroundColor = [UIColor whiteColor];
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    UIImageView *tmpView = [[UIImageView alloc] initWithImage:self.image];
    [tmpView setFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 30)];
    tmpView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:tmpView];
    self.image = [UIImage new];
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 3);
    self.layer.shadowOpacity = 0.7;
}

@end
