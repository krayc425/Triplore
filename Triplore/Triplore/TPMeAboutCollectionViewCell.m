//
//  TPAboutCollectionViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeAboutCollectionViewCell.h"
#import "TPPersonModel.h"

@interface TPMeAboutCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *introductionText;

@end


@implementation TPMeAboutCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    self.avatarView.layer.cornerRadius = CGRectGetWidth(self.frame)/6;
    
    
    NSLog(@"%f", CGRectGetWidth(self.frame));
    
}
- (void)setPerson:(TPPersonModel *)person {
    _person = person;
    self.avatarView.image = [UIImage imageNamed:person.avatarName];
    self.nameLabel.text = person.name;
    self.introductionText.text = person.introduction;
}

@end
