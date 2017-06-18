//
//  TPNoteCollectionViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteCollectionViewCell.h"


@implementation TPNoteCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    [self.dateLabel setBackgroundColor:TPColor];
    [self.dateLabel setTextColor:[UIColor whiteColor]];
    
    [self.titleLabel setTextColor:[UIColor colorWithRed:94.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0]];
    
    [self.contentLabel setTextColor:[UIColor colorWithRed:177.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0]];
}

@end
