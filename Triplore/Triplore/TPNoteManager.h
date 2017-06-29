//
//  TPNoteManager.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPNote;

@interface TPNoteManager : NSObject

/**
 插入一个笔记

 @param note 笔记模型
 @return 是否插入成功
 */
+ (BOOL)insertNote:(TPNote *_Nonnull)note;

/**
 更新一个笔记

 @param note 笔记模型
 @return 是否更新成功
 */
+ (BOOL)updateNote:(TPNote *_Nonnull)note;

/**
 删除一个笔记

 @param noteid 笔记 id
 @return  是否删除成功
 */
+ (BOOL)deleteNoteWithID:(NSInteger)noteid;

/**
 得到一个笔记

 @param noteid 笔记 id
 @return 笔记模型，如没有则是 NULL
 */
+ (TPNote *_Nullable)fetchNoteWithID:(NSInteger)noteid;

/**
 得到所有笔记，按创建时间排序

 @return 笔记模型数组
 */
+ (NSArray<TPNote *> *_Nonnull)fetchAllNotes;

/**
 得到笔记数量

 @return 笔记数量
 */
+ (NSInteger)countNoteNumbers;

/**
 更新服务器 id

 @param note  笔记模型
 @param serverid 服务器 id（可为 NULL）
 @return 是否添加成功
 */
+ (BOOL)updateNote:(TPNote *_Nonnull)note withServerID:(NSString *_Nullable)serverid;

@end
