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
    return [[[DBManager shareInstance] getDB] executeUpdate:@"INSERT INTO t_note (videoid, views, createTime, title, template) VALUES (?, ?, ?, ?, ?)", note.videoid, arrayData, note.createTime, note.title, @(note.templateNum)];
}

+ (BOOL)updateNote:(TPNote *_Nonnull)note{
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:note.views];
    return [[[DBManager shareInstance] getDB] executeUpdate:@"UPDATE t_note SET title = ?, views = ?, template = ? WHERE noteid = ?;", note.title, arrayData, @(note.templateNum), @(note.noteid)];
}

+ (BOOL)deleteNoteWithID:(NSInteger)noteid{
    return [[[DBManager shareInstance] getDB] executeUpdate:@"DELETE FROM t_note WHERE noteid = ?", @(noteid)];
}

+ (TPNote *)fetchNoteWithID:(NSInteger)noteid{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_note WHERE noteid = ?;", @(noteid)];
    if([resultSet next]){
        TPNote *note = [TPNote new];
        [note setNoteid:[resultSet intForColumn:@"noteid"]];
        [note setVideoid:[resultSet stringForColumn:@"videoid"]];
        [note setTitle:[resultSet stringForColumn:@"title"]];
        [note setCreateTime:[resultSet dateForColumn:@"createTime"]];
        NSArray *noteViewArr = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"views"]];
        [note setViews:[NSMutableArray arrayWithArray:noteViewArr]];
        [note setTemplateNum:[resultSet intForColumn:@"template"]];
        return note;
    }
    return NULL;
}

+ (NSArray<TPNote *> *)fetchAllNotes{
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_note ORDER BY createTime DESC;"];
    while([resultSet next]){
        TPNote *note = [TPNote new];
        [note setNoteid:[resultSet intForColumn:@"noteid"]];
        [note setVideoid:[resultSet stringForColumn:@"videoid"]];
        [note setTitle:[resultSet stringForColumn:@"title"]];
        [note setCreateTime:[resultSet dateForColumn:@"createTime"]];
        NSArray *noteViewArr = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"views"]];
        [note setViews:[NSMutableArray arrayWithArray:noteViewArr]];
        [note setTemplateNum:[resultSet intForColumn:@"template"]];
        [resultArr addObject:note];
    }
    return resultArr;
}

+ (NSInteger)countNoteNumbers{
    return [[self fetchAllNotes] count];
}

@end
