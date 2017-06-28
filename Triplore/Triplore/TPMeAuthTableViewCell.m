//
//  TPMeAuthTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeAuthTableViewCell.h"
#import "TPAuthHelper.h"

@interface TPMeAuthTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation TPMeAuthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame)/2;
    
}

- (void)setUser:(AVUser *)user {
    _user = user;
    self.usernameLabel.text = user.username;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
