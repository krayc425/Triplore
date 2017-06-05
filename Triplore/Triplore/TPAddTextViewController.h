//
//  TPAddTextViewController.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPAddMode){
    TPAddNote     = 1,
    TPUpdateNote  = 2,
    TPUpdateTitle = 3,
};

@protocol TPAddNoteViewDelegate <NSObject>

@optional

/**
 增加笔记 View

 @param view 笔记 View
 */
- (void)addNoteView:(UIView *_Nonnull)view;

/**
  更新笔记 View

 @param view 笔记 View
 */
- (void)updateNoteView:(UIView *_Nonnull)view;

/**
 更新标题
 
 @param title 标题 String 
 */
- (void)updateTitle:(NSString *_Nonnull)title;

@end

@interface TPAddTextViewController : UIViewController

@property (nonnull, nonatomic) id<TPAddNoteViewDelegate> addNoteViewDelegate;

@property (nonnull, nonatomic) NSString *noteString;
@property (nonatomic) TPAddMode addMode;

@end
