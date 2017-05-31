//
//  TPNoteCollectionViewCell+Configure.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteCollectionViewCell+Configure.h"
#import "TPNote.h"

@implementation TPNoteCollectionViewCell (Configure)

- (void)configureWithNote:(TPNote *)note{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd\nMMM"];
    NSString *dateString = [dateFormatter stringFromDate:note.createTime];
    [self.dateLabel setText:dateString];
    
    [self.titleLabel setText:note.title];
    
    for(UIView *view in note.views){
        if([view isKindOfClass:[UILabel class]]){
            UILabel *labelView = (UILabel *)view;
            [self.contentLabel setText:labelView.text];
        }
//        if([view isKindOfClass:[])
    }
    
}

@end
