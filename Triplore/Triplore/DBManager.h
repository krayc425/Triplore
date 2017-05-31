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

+ (_Nonnull instancetype)shareInstance;
- (void)establishDB;
- (FMDatabase *_Nonnull)getDB;
- (void)closeDB;
- (NSString *_Nonnull)getDBPath;
- (long long)dbFilesize;

@end
