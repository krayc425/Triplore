//
//  TPMeAuthTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeAuthTableViewCell.h"
#import "TPAuthHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TPMeAuthTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation TPMeAuthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) / 2;
}

- (void)setUser:(AVUser *)user {
    _user = user;
    if (user) {
        self.usernameLabel.text = user.username;
        
        AVFile *file = [user objectForKey:@"avatar"];
        
        NSLog(@"Avatar URL : %@", file.url);
        
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:file.url]];
    }else{
        self.usernameLabel.text = @"未登录";
        
        [self.avatarImageView setImage:[UIImage imageNamed:@"DEFAULT_AVATAR"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
