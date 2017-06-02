//
//  DBManager.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface DBManager : NSObject

@property (nonatomic, nullable) FMDatabase *db;

/**
 得到单例

 @return Manager 单例
 */
+ (_Nonnull instancetype)shareInstance;

/**
 建立数据库
 */
- (void)establishDB;

/**
 得到数据库引用

 @return 数据库引用
 */
- (FMDatabase *_Nonnull)getDB;

/**
 关闭数据库
 */
- (void)closeDB;

/**
 得到数据库路径

 @return 数据库路径
 */
- (NSString *_Nonnull)getDBPath;

/**
 得到数据库缓存大小

 @return 数据库缓存大小
 */
- (long long)dbFilesize;

@end
