//
//  TPNoteManager.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

/**
 *  创建笔记的时候的 Manager，单例
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TPNoteCreator : NSObject

/**
 得到单例

 @return NoteCreator Singleton
 */
+ (_Nonnull instancetype)shareInstance;

- (void)addNoteView:(UIView *_Nonnull)view;

- (NSInteger)countNoteView;

- (NSArray *_Nonnull)getNoteViews;

- (void)clearNoteView;

@end
