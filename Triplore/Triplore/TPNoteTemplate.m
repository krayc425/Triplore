//
//  TPNoteTemplate.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteTemplate.h"

@implementation TPNoteTemplate

- (instancetype)initWithColor:(UIColor *)color andFont:(UIFont *)font andTitleView:(TPNoteTitleView *)titleView andImageStyle:(TPNoteTemplateNumber)number{
    self = [super init];
    if(self){
        self.tem_color = color;
        self.tem_font = font;
        self.tem_titleView = titleView;
        self.tem_num = number;
    }
    return self;
}

@end
