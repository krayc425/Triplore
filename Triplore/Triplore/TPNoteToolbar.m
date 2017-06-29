//
//  TPNoteToolbar.m
//  Triplore
//
//  Created by Sorumi on 17/6/29.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteToolbar.h"
#import "TPNoteBarButton.h"

@interface TPNoteToolbar ()

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *exportButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *addButton;

@end

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

- (void)setMode:(TPNoteToolbarMode)mode {
    _mode = mode;
    [self setButtons];
}

- (void)setButtons {
    
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = CGRectGetWidth(self.frame) / 4;
    CGFloat height = CGRectGetHeight(self.frame) - 4;
    CGRect rect1 = CGRectMake(0, 4, width, height);
    CGRect rect2 = CGRectMake(width*1, 4, width, height);
    CGRect rect3 = CGRectMake(width*2, 4, width,height);
    CGRect rect4 = CGRectMake(width*3, 4, width,height);

    switch (self.mode) {
        case TPNoteToolbarLocal:
        {
            self.deleteButton = [self buttonWithFrame:rect1 title:@"删除" image:@"NOTE_DELETE" action:@selector(deleteButtonDidTap:)];
            self.videoButton = [self buttonWithFrame:rect2 title:@"观看视频" image:@"NOTE_VIDEO" action:@selector(videoButtonDidTap:)];
            self.exportButton = [self buttonWithFrame:rect3 title:@"保存到相册" image:@"NOTE_EXPORT" action:@selector(exportButtonDidTap:)];
            self.shareButton = [self buttonWithFrame:rect4 title:@"分享" image:@"NOTE_SHARE" action:@selector(shareButtonDidTap:)];
            
            [self addSubview:self.deleteButton];
            [self addSubview:self.videoButton];
            [self addSubview:self.exportButton];
            [self addSubview:self.shareButton];
        }
            break;
        case TPNoteToolbarRemote:
        {
            self.likeButton = [self buttonWithFrame:rect1 title:@"赞" image:@"NOTE_LIKE" action:@selector(likeButtonDidTap:)];
            self.collectButton = [self buttonWithFrame:rect2 title:@"收藏" image:@"ME_COLLECT" action:@selector(collectButtonDidTap:)];
            self.videoButton = [self buttonWithFrame:rect3 title:@"观看视频" image:@"NOTE_VIDEO" action:@selector(videoButtonDidTap:)];
            self.addButton = [self buttonWithFrame:rect4 title:@"添加到我的" image:@"NOTE_EXPORT" action:@selector(addButtonDidTap:)];
            
            [self addSubview:self.likeButton];
            [self addSubview:self.collectButton];
            [self addSubview:self.videoButton];
            [self addSubview:self.addButton];

        }
            break;
            
        default:
            break;
    }

}

- (void)setIsLike:(BOOL)isLike {
    _isLike = isLike;
    [self.likeButton setImage:[UIImage imageNamed:_isLike ? @"NOTE_LIKE_FULL" : @"NOTE_LIKE"] forState:UIControlStateNormal];
    [self.likeButton setTitle:[NSString stringWithFormat:_isLike ? @"已赞 · %d" : @"赞 · %d", self.likeCount] forState:UIControlStateNormal];
}

- (void)setIsCollect:(BOOL)isCollect {
    _isCollect = isCollect;
    [self.collectButton setImage:[UIImage imageNamed:isCollect ? @"ME_COLLECT_FULL" : @"ME_COLLECT"] forState:UIControlStateNormal];
    [self.collectButton setTitle:isCollect ? @"已收藏" : @"收藏" forState:UIControlStateNormal];
}

- (void)setIsShare:(BOOL)isShare {
    _isShare = isShare;
    [self.collectButton setTitle:isShare ? @"已分享" : @"分享" forState:UIControlStateNormal];
}

- (void)setLikeCount:(NSUInteger)likeCount {
    _likeCount = likeCount;
    [self.likeButton setTitle:[NSString stringWithFormat:self.isLike ? @"已赞 · %d" : @"赞 · %d", likeCount] forState:UIControlStateNormal];
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

- (void)likeButtonDidTap:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didTapLikeButton:)]) {
        [_delegate didTapLikeButton:button];
    }
}

- (void)collectButtonDidTap:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didTapCollectButton:)]) {
        [_delegate didTapCollectButton:button];
    }
}

- (void)addButtonDidTap:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didTapAddButton:)]) {
        [_delegate didTapAddButton:button];
    }
}


@end
