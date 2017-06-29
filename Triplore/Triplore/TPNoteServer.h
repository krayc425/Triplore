//
//  TPNoteServer.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPNote;
@class AVObject;

/**
 服务器上的笔记模型
 */
@interface TPNoteServer : NSObject

@property (nonatomic, copy, nonnull) NSString *noteServerID;
@property (nonatomic, copy, nonnull) NSString *title;
@property (nonatomic, nonnull) NSNumber *like;
@property (nonatomic, nullable) NSData *views;
@property (nonatomic, nonnull) NSDictionary *videoDict;
@property (nonatomic, copy, nonnull) NSString *creatorName;

- (instancetype _Nonnull)initWithTPNote:(TPNote *_Nonnull)note;

- (instancetype _Nonnull)initWithAVObject:(AVObject *_Nonnull)object;

@end
