//
//  TPNoteCollectionViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteCollectionViewCell.h"
#import "TPNote.h"
#import "TPNoteServer.h"

@interface TPNoteCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

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

- (void)setNote:(TPNote *)note {
    _note = note;
    [self configureWithNote:note];
}

- (void)setNoteServer:(TPNoteServer *)noteServer {
    _noteServer = noteServer;
    [self configureWithNoteServer:noteServer];
}

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
    
    self.mode = TPNoteCellLocal;
}

- (void)configureWithNoteServer:(TPNoteServer *)noteServer{
    TPNote *note = [[TPNote alloc] initWithTPNoteServer:noteServer];
    [self configureWithNote:note];
    
    [self.likeCountLabel setText:[NSString stringWithFormat:@"%d", noteServer.like.intValue]];
    [self.usernameLabel setText:noteServer.creatorName];
    
    self.mode = TPNoteCellRemote;
}

- (IBAction)likeButtonDidTap:(id)sender {
    if ([_delegate respondsToSelector:@selector(didTapLikeButtonWithNote:)]) {
        [_delegate didTapLikeButtonWithNote:self.noteServer];
    }
}

@end
