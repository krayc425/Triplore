//
//  TPNoteServerHelper.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPNoteServer;

@interface TPNoteServerHelper : NSObject

/**
 上传本地笔记到服务器

 @param note 笔记模型
 @param completionBlock 回调块
 */
+ (void)uploadNote:(TPNoteServer *_Nonnull)note withBlock:(void(^_Nonnull)(BOOL succeed, NSString * _Nullable serverID, NSError *_Nullable error))completionBlock;

/**
 得到所有的笔记

 @param completionBlock 回调块
 */
+ (void)loadServerNotesStartWith:(NSUInteger)start withSize:(NSUInteger)size withBlock:(void(^_Nonnull)(NSArray<TPNoteServer *> * _Nonnull noteServers, NSError *_Nullable error))completionBlock;

/**
 评论笔记

 @param note 笔记模型
 @param isLike 是否喜欢？赞 or 踩
 @param completionBlock 回调块
 */
+ (void)commentNote:(TPNoteServer *_Nonnull)note withIsLike:(BOOL)isLike withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock;

@end
