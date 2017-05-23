//
//  TPSiteTableViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSiteTableViewCell.h"
#import "Utilities.h"

@implementation TPSiteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.categoryLabel sizeToFit];
    
    [self.categoryLabel setTextColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]];
    [self.allButton setTitleColor:[Utilities getColor] forState:UIControlStateNormal];
    [self.allButton2 setTitleColor:[Utilities getColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
