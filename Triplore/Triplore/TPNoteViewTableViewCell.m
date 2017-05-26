//
//  TPNoteViewTableViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/26.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteViewTableViewCell.h"

@implementation TPNoteViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNoteView:(UIView *)noteView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20,
                                                           10,
                                                           CGRectGetWidth(noteView.frame) - 20,
                                                           CGRectGetHeight(noteView.frame) - 20)];
    [view addSubview:noteView];
    [self addSubview:view];
}

@end
