//
//  TPMeLogoutTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeLogoutTableViewCell.h"

@implementation TPMeLogoutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
