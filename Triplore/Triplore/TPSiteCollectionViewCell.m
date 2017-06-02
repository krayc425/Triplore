//
//  TPSiteCollectionViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/5/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSiteCollectionViewCell.h"
#import "Utilities.h"

@implementation TPSiteCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = [UIColor lightGrayColor];
    
    
    self.overlayView.backgroundColor = nil;
    
    self.imageView.image = [UIImage imageNamed:@"TEST_PNG"];
  
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    for (CALayer *layer in self.overlayView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    UIColor *darkColor = [Utilities getGradientColorDark];
    
    gradientLayer.colors = @[(id)darkColor.CGColor, (id)[UIColor clearColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    
    [self.overlayView.layer insertSublayer:gradientLayer atIndex:0];
}

@end
