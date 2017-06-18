//
//  TPCityInfoTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPCityInfoTableViewCell.h"
#import "TPCategoryButton.h"
#import "Utilities.h"
#import "TPCityModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TPCityInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet TPCategoryButton *foodButton;
@property (weak, nonatomic) IBOutlet TPCategoryButton *shoppingButton;
@property (weak, nonatomic) IBOutlet TPCategoryButton *placeButton;

@end

@implementation TPCityInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgImageView.image = [UIImage imageNamed:@"TEST_PNG"];
    self.overlayView.backgroundColor = nil;
    
    // buttons
    
    NSArray *buttons = @[self.foodButton, self.shoppingButton, self.placeButton];
    
    NSInteger start = 11;
    for (UIButton *button in buttons) {
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = start;
        [button addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        start ++;

    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //
    for (CALayer *layer in self.overlayView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds)/7
                                     *3);
    UIColor *darkColor = TPGradientColor;
    
    gradientLayer.colors = @[(id)darkColor.CGColor, (id)[UIColor clearColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    
    [self.overlayView.layer insertSublayer:gradientLayer atIndex:0];
    
}

- (void)setCity:(TPCityModel *)city {
    _city = city;
    self.siteLabel.text = city.chineseName;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:city.imageURL]];
    
}

- (void)clickCategoryButton:(UIButton *)button {
    if([self.delegate respondsToSelector:@selector(didTapCategory:)]) {
        [self.delegate didTapCategory:button.tag - 10];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
