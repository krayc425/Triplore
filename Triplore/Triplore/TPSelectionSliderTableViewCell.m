//
//  TPSelectionSliderTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/14.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSelectionSliderTableViewCell.h"
#import "SDCycleScrollView.h"
#import "TPCategoryButton.h"

@interface TPSelectionSliderTableViewCell ()

@property (weak, nonatomic) IBOutlet TPCategoryButton *foodButton;
@property (weak, nonatomic) IBOutlet TPCategoryButton *shoppingButton;
@property (weak, nonatomic) IBOutlet TPCategoryButton *placeButton;

@end

@implementation TPSelectionSliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGRect frame = CGRectMake(0, 0, width, width / 7 * 3);
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageNamesGroup:@[@"TEST_PNG", @"TEST_PNG", @"TEST_PNG"]];
    [self addSubview:cycleScrollView];
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
