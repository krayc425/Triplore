//
//  TPNoteTemplateFactory.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteTemplateFactory.h"
#import "TPNoteTitleViewGreen.h"
#import "TPNoteTitleViewBrown.h"


@implementation TPNoteTemplateFactory

+ (TPNoteTemplate *)getTemplateOfNum:(TPNoteTemplateNumber)number{
    switch (number) {
        case TPGreen:
        {
            TPNoteTitleViewGreen *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TPNoteTitleViewGreen" owner:nil options:nil] lastObject];
            return [[TPNoteTemplate alloc] initWithColor:[UIColor whiteColor]
                                                 andFont:TPFont
                                            andTitleColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]
                                            andTextColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]
                                            andTitleView:titleView
                                           andImageStyle:TPGreen];
        }
            break;
        case TPBrown:
        {
            TPNoteTitleViewBrown *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TPNoteTitleViewBrown" owner:nil options:nil] lastObject];
            return [[TPNoteTemplate alloc] initWithColor:[UIColor colorWithRed:247.0/255.0 green:244.0/255.0 blue:243.0/255.0 alpha:1.0]
                                                 andFont:TPFont
                                           andTitleColor:[UIColor colorWithRed:75.0/255.0 green:66.0/255.0 blue:58.0/255.0 alpha:1.0]
                                            andTextColor:[UIColor colorWithRed:125.0/255.0 green:122.0/255.0 blue:118.0/255.0 alpha:1.0]
                                            andTitleView:titleView
                                           andImageStyle:TPBrown];
        }
            break;
        default:
            break;
    }
}

@end
