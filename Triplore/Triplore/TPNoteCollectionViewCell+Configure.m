//
//  TPNoteCollectionViewCell+Configure.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteCollectionViewCell+Configure.h"
#import "TPNoteServer.h"
#import "TPNote.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation TPNoteCollectionViewCell (Configure)

- (void)configureWithNote:(TPNote *)note{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd\nMMM"];
    NSString *dateString = [dateFormatter stringFromDate:note.createTime];
    [self.dateLabel setText:dateString];
    
    if([note.title isEqualToString:@""] || note.title == NULL){
        [self.titleLabel setText:@"暂无标题"];
    }else{
        [self.titleLabel setText:note.title];
    }
    
    BOOL hasTitle = YES;
    BOOL hasImage = YES;
    [self.contentLabel setText:@""];
    [self.backgroundImgView setImage:[UIImage new]];
    for(UIView *view in note.views){
        if(hasTitle && [view isKindOfClass:[UILabel class]]){
            UILabel *labelView = (UILabel *)view;
            [self.contentLabel setText:labelView.text];
            hasTitle = NO;
        }
        if(hasImage && [view isKindOfClass:[UIImageView class]]){
            UIImageView *imgView = (UIImageView *)view;
            [self.backgroundImgView setImage:imgView.image];
            [self.backgroundImgView setContentMode:UIViewContentModeScaleAspectFit];
            hasImage = NO;
        }
    }
}

- (void)configureWithNoteServer:(TPNoteServer *)noteServer{
    TPNote *note = [[TPNote alloc] initWithTPNoteServer:noteServer];
    [self configureWithNote:note];
}

@end
