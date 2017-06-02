//
//  TPCityInfoTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPCityInfoTableViewCell.h"
#import "CategoryButton.h"
#import "Utilities.h"

@interface TPCityInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet CategoryButton *foodButton;
@property (weak, nonatomic) IBOutlet CategoryButton *shoppingButton;
@property (weak, nonatomic) IBOutlet CategoryButton *placeButton;

@end

@implementation TPCityInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundImage.image = [UIImage imageNamed:@"TEST_PNG"];
    
    // buttons
    self.foodButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.foodButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.shoppingButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.shoppingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.placeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.placeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    //
//    for (CALayer *layer in self.overlayView.layer.sublayers) {
//        [layer removeFromSuperlayer];
//    }
//    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.overlayView.bounds;
//    UIColor *darkColor = [Utilities getGradientColorDark];
//    
//    gradientLayer.colors = @[(id)darkColor.CGColor, (id)[UIColor clearColor].CGColor];
//    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
//    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
//    
//    [self.overlayView.layer insertSublayer:gradientLayer atIndex:0];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
