//
//  TPNoteManager.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteManager.h"
#import "DBManager.h"
#import "TPNote.h"

@implementation TPNoteManager{
    FMDatabase *db;
}

+ (BOOL)insertNote:(TPNote *)note{
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:note.views];
    return [[[DBManager shareInstance] getDB] executeUpdate:@"INSERT INTO t_note (videoid, views, createTime, title) VALUES (?, ?, ?, ?)", @(note.videoid), arrayData, note.createTime, note.title];
}

+ (BOOL)deleteNoteWithID:(NSInteger)noteid{
    return [[[DBManager shareInstance] getDB] executeUpdate:@"DELETE FROM t_note WHERE noteid = ?", @(noteid)];
}

+ (TPNote *)fetchNoteWithID:(NSInteger)noteid{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_note WHERE noteid = ?;", @(noteid)];
    if([resultSet next]){
        TPNote *note = [TPNote new];
        [note setNoteid:[resultSet intForColumn:@"noteid"]];
        [note setVideoid:[resultSet intForColumn:@"videoid"]];
        [note setTitle:[resultSet stringForColumn:@"title"]];
        [note setCreateTime:[resultSet dateForColumn:@"createTime"]];
        NSArray *noteViewArr = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"views"]];
        [note setViews:noteViewArr];
        return note;
    }
    return NULL;
}

+ (NSArray<TPNote *> *)fetchAllNotes{
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_note;"];
    while([resultSet next]){
        TPNote *note = [TPNote new];
        [note setNoteid:[resultSet intForColumn:@"noteid"]];
        [note setVideoid:[resultSet intForColumn:@"videoid"]];
        [note setTitle:[resultSet stringForColumn:@"title"]];
        [note setCreateTime:[resultSet dateForColumn:@"createTime"]];
        NSArray *noteViewArr = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"views"]];
        [note setViews:noteViewArr];
        
        [resultArr addObject:note];
    }
    return resultArr;
}

+ (NSInteger)countNoteNumbers{
    return [[self fetchAllNotes] count];
}

@end
