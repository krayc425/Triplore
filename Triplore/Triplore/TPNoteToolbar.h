//
//  TPNoteToolbar.h
//  Triplore
//
//  Created by Sorumi on 17/6/29.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPNoteToolbarMode){
    TPNoteToolbarLocal      = 1,
    TPNoteToolbarRemote     = 2,
};


@protocol TPNoteToolbarDelegate <NSObject>

@optional

- (void) didTapDeleteButton:(UIButton *_Nonnull)button;
- (void) didTapVideoButton:(UIButton *_Nonnull)button;
- (void) didTapExportButton:(UIButton *_Nonnull)button;
- (void) didTapShareButton:(UIButton *_Nonnull)button;
- (void) didTapLikeButton:(UIButton *_Nonnull)button;
- (void) didTapCollectButton:(UIButton *_Nonnull)button;
- (void) didTapAddButton:(UIButton *_Nonnull)button;

@end

/**
 笔记底部工具栏
 */
@interface TPNoteToolbar : UIView

@property (nonatomic) TPNoteToolbarMode mode;
@property (nonatomic) BOOL isLike;
@property (nonatomic) BOOL isCollect;
@property (nonatomic) NSUInteger likeCount;
@property (nonatomic) BOOL isShare;

@property (nonatomic, weak, nullable) id<TPNoteToolbarDelegate> delegate;

@end
