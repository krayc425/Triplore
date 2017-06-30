//
//  TPNote.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TPNoteTemplate.h"

@class TPNoteServer;

/**
 存入数据库的 Note 模型
 */
@interface TPNote : NSObject <NSCoding>

@property (nonatomic) NSInteger noteid;
@property (copy, nonatomic, nonnull) NSString *videoid;
@property (copy, nonatomic, nonnull) NSDate *createTime;
@property (nonatomic, nonnull) NSString *title;
@property (nonatomic, nonnull) NSMutableArray<UIView *> *views;
@property (nonatomic) TPNoteTemplateNumber templateNum;
@property (nonatomic, copy, nullable) NSString *serverid;

- (id _Nonnull )initWithTPNoteServer:(TPNoteServer *_Nonnull)noteServer;

@end
