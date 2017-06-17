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
#import "Utilities.h"

@implementation TPNoteTemplateFactory

+ (TPNoteTemplate *)getTemplateOfNum:(TPNoteTemplateNumber)number{
    switch (number) {
        case TPGreen:
        {
            TPNoteTitleViewGreen *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TPNoteTitleViewGreen" owner:nil options:nil] lastObject];
            return [[TPNoteTemplate alloc] initWithColor:[UIColor whiteColor]
                                                 andFont:[Utilities getFont]
                                            andTitleView:titleView
                                           andImageStyle:TPGreen];
        }
            break;
        case TPBrown:
        {
            TPNoteTitleViewBrown *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TPNoteTitleViewBrown" owner:nil options:nil] lastObject];
            return [[TPNoteTemplate alloc] initWithColor:[UIColor colorWithRed:247.0/255.0 green:244.0/255.0 blue:243.0/255.0 alpha:1.0]
                                                 andFont:[Utilities getFont]
                                            andTitleView:titleView
                                           andImageStyle:TPBrown];
        }
            break;
        default:
            break;
    }
}

@end
