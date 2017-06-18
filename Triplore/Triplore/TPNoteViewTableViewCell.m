//
//  TPNoteViewTableViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/26.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteViewTableViewCell.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface TPNoteViewTableViewCell(){
    UIView *deleteView;
}

@end

@implementation TPNoteViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = self.bgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setNoteView:(UIView *)noteView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20,
                                                            10,
                                                            CGRectGetWidth(self.frame) - 40,
                                                            CGRectGetHeight(noteView.frame) - 20)];
    [view setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:noteView];
    view.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin
    |UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:view];
    
    //自定义删除 View
    deleteView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth,
                                                                  0,
                                                                  300,
                                                                  CGRectGetHeight(noteView.frame) + 20)];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        90,
                                                                        CGRectGetHeight(deleteView.frame))];
    [deleteButton setImage:[UIImage imageNamed:@"CELL_DELETE"] forState:UIControlStateNormal];
    [deleteView addSubview:deleteButton];
    
    [self addSubview:deleteView];
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    deleteView.backgroundColor = bgColor;
}

@end
