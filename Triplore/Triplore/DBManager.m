//
//  DBManager.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "DBManager.h"

#define GROUP_ID @"group.com.krayc.Triplorex"

@implementation DBManager

static DBManager * _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [DBManager shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self establishDB];
    }
    return self;
}

- (void)establishDB{
    //数据库路径
    
    NSString *doc = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:GROUP_ID] path];
    NSString *fileName = [doc stringByAppendingPathComponent:@"task.sqlite"];
    
    NSLog(@"DB PATH : %@", doc);
    NSLog(@"FILE PATH : %@", fileName);
    
    //获得数据库
    self.db = [FMDatabase databaseWithPath:fileName];
    //使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([self.db open]){
        //创表
        
        //先看有没有这张表
        if(![self.db tableExists:@"t_task"]){
            BOOL result = [self.db executeUpdate:
                      @"CREATE TABLE IF NOT EXISTS t_video (videoid integer PRIMARY KEY AUTOINCREMENT, dict blob NOT NULL)"];
            if (result){
                NSLog(@"创建表 video 成功");
            }
            
            result = [self.db executeUpdate:
                           @"CREATE TABLE IF NOT EXISTS t_note (noteid integer PRIMARY KEY AUTOINCREMENT, videoid integer NOT NULL, views blob NOT NULL, createTime date NOT NULL, title varchar,  CONSTRAINT fk_t_note_videoid_t_video_videoid FOREIGN KEY(videoid) REFERENCES t_video(videoid))"];
            if (result){
                NSLog(@"创建表 note 成功");
            }
            
        }else{
            //更新数据库表
            
//            if (![self.db columnExists:@"image" inTableWithName:@"t_task"]){
//                [self.db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ blob", @"t_task", @"image"]];
//                NSLog(@"增加图片字段成功");
//            }
            
        }
        
        //清理数据库缓存
        [self.db executeStatements:@"VACUUM t_task"];
    }
    
    NSLog(@"Current Path: %@", self.getDBPath);
    
}

- (FMDatabase *_Nonnull)getDB{
    return self.db;
}

- (void)closeDB{
    NSLog(@"db close");
    [self.db clearCachedStatements];
    [self.db close];
    self.db = NULL;
}

- (NSString *)getDBPath{
    NSString *doc = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:GROUP_ID] path];
    NSString *fileName = [doc stringByAppendingPathComponent:@"task.sqlite"];
    return fileName;
}

- (long long)dbFilesize{
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.getDBPath]){
        return [[manager attributesOfItemAtPath:self.getDBPath error:nil] fileSize];
    }
    return 0;
}

@end
