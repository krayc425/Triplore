//
//  TPFontTableViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/16.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPFontTableViewCell.h"

@implementation TPFontTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.fontLabel setTextColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
