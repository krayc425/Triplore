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

typedef NS_ENUM(NSInteger, TPNoteToolbarShareMode){
    TPNoteToolbarShareNone      = 1,
    TPNoteToolbarShareAlready   = 2,
};

typedef NS_ENUM(NSInteger, TPNoteToolbarLikeMode){
    TPNoteToolbarLikeNone       = 1,
    TPNoteToolbarLikeAlready    = 2,
};

typedef NS_ENUM(NSInteger, TPNoteToolbarCollectMode){
    TPNoteToolbarCollectNone       = 1,
    TPNoteToolbarCollectAlready    = 2,
};


@protocol TPNoteToolbarDelegate <NSObject>

@optional

- (void) didTapDeleteButton:(UIButton *_Nonnull)button;
- (void) didTapVideoButton:(UIButton *_Nonnull)button;
- (void) didTapExportButton:(UIButton *_Nonnull)button;
- (void) didTapShareButton:(UIButton *_Nonnull)button;

@end

@interface TPNoteToolbar : UIView

@property (nonatomic, weak, nullable) id<TPNoteToolbarDelegate> delegate;

@end
