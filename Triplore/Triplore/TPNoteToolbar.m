//
//  TPNoteToolbar.m
//  Triplore
//
//  Created by Sorumi on 17/6/29.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteToolbar.h"
#import "TPNoteBarButton.h"

@implementation TPNoteToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.3;

    [self setButtons];
}

- (void)setButtons {
    
    CGFloat width = CGRectGetWidth(self.frame) / 4;
    CGFloat height = CGRectGetHeight(self.frame) - 4;
    CGRect rect1 = CGRectMake(0, 4, width, height);
    CGRect rect2 = CGRectMake(width*1, 4, width, height);
    CGRect rect3 = CGRectMake(width*2, 4, width,height);
    CGRect rect4 = CGRectMake(width*3, 4, width,height);
 
    UIButton *deleteButton = [self buttonWithFrame:rect1 title:@"删除" image:@"NOTE_DELETE" action:@selector(deleteButtonDidTap:)];
    UIButton *videoButton = [self buttonWithFrame:rect2 title:@"观看视频" image:@"NOTE_VIDEO" action:@selector(videoButtonDidTap:)];
    UIButton *exportButton = [self buttonWithFrame:rect3 title:@"保存到相册" image:@"NOTE_EXPORT" action:@selector(exportButtonDidTap:)];
    UIButton *shareButton = [self buttonWithFrame:rect4 title:@"分享" image:@"NOTE_SHARE" action:@selector(shareButtonDidTap:)];
        
    [self addSubview:deleteButton];
    [self addSubview:videoButton];
    [self addSubview:exportButton];
    [self addSubview:shareButton];
    
}


- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image action:(nonnull SEL)action
{
    TPNoteBarButton *button = [[TPNoteBarButton alloc] initWithFrame:frame];
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TPColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Action

- (void)deleteButtonDidTap:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didTapDeleteButton:)]) {
        [_delegate didTapDeleteButton:button];
    }
    
}

- (void)videoButtonDidTap:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didTapVideoButton:)]) {
        [_delegate didTapVideoButton:button];
    }
}

- (void)exportButtonDidTap:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didTapExportButton:)]) {
        [_delegate didTapExportButton:button];
    }
}

- (void)shareButtonDidTap:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didTapShareButton:)]) {
        [_delegate didTapShareButton:button];
    }
}

@end
