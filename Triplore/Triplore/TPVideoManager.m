//
//  TPVideoManager.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/1.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideoManager.h"
#import "DBManager.h"
#import "TPVideo.h"

@implementation TPVideoManager

+ (BOOL)insertVideo:(TPVideo *)video{
    if([self fetchVideoWithID:video.videoid] == NULL){
        NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:video.dict];
        return [[[DBManager shareInstance] getDB] executeUpdate:@"INSERT INTO t_video (videoid, dict, favorite, recent) VALUES (?, ?, ?, ?)", video.videoid, dictData, @(0), [NSDate date]];
    }else{
        //如果已经有了，就更新一下最近日期
        FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE videoid = ?;", video.videoid];
        if([resultSet next]){
            return [[[DBManager shareInstance] getDB] executeUpdate:@"UPDATE t_video SET recent = ? WHERE videoid = ?;", [NSDate date], video.videoid];
        }
    }
    return NO;
}

+ (TPVideo *_Nullable)fetchVideoWithID:(NSString *)videoid{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE videoid = ?;", videoid];
    if([resultSet next]){
        TPVideo *video = [TPVideo new];
        [video setVideoid:videoid];
        NSDictionary *dict = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"dict"]];
        [video setDict:dict];
        [video setFavorite:[resultSet intForColumn:@"favorite"]];
        [video setRecent:[resultSet dateForColumn:@"recent"]];
        return video;
    }
    return NULL;
}

+ (BOOL)commentVideo:(TPVideo *_Nonnull)video{
    //如果没有，就插入这个视频
    if([self fetchVideoWithID:video.videoid] == NULL){
        [self insertVideo:video];
    }
    //设置这个视频的：是否收藏
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE videoid = ?;", video.videoid];
    NSLog(@"Is Favorite: %d for %@", [self isFavoriteVideo:video.videoid], video.videoid);
    if([resultSet next]){
        return [[[DBManager shareInstance] getDB] executeUpdate:@"UPDATE t_video SET favorite = ? WHERE videoid = ?;", ([self isFavoriteVideo:video.videoid] ? @(0) : @(1)), video.videoid];
    }
    return NO;
}

+ (BOOL)isFavoriteVideo:(NSString *)videoid{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE videoid = ?;", videoid];
    if([resultSet next]){
        return ([resultSet intForColumn:@"favorite"] == 1);
    }
    return NO;
}

+ (NSArray<TPVideo *> *_Nullable)fetchFavoriteVideos{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE favorite = ?;", @(1)];
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    while([resultSet next]){
        TPVideo *video = [TPVideo new];
        [video setVideoid:[resultSet stringForColumn:@"videoid"]];
        NSDictionary *dict = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"dict"]];
        [video setDict:dict];
        [video setFavorite:[resultSet intForColumn:@"favorite"]];
        [video setRecent:[resultSet dateForColumn:@"recent"]];
        [resultArr addObject:video];
    }
    return resultArr.count == 0 ? NULL : resultArr;
}

+ (NSArray<TPVideo *> *_Nullable)fetchRecentVideos{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE recent IS NOT NULL;"];
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    while([resultSet next]){
        TPVideo *video = [TPVideo new];
        [video setVideoid:[resultSet stringForColumn:@"videoid"]];
        NSDictionary *dict = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"dict"]];
        [video setDict:dict];
        [video setFavorite:[resultSet intForColumn:@"favorite"]];
        [video setRecent:[resultSet dateForColumn:@"recent"]];
        [resultArr addObject:video];
    }
    //按时间倒序
    [resultArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TPVideo *v1 = (TPVideo *)obj1;
        TPVideo *v2 = (TPVideo *)obj2;
        return [v2.recent timeIntervalSinceDate:v1.recent] > 0;
    }];
    return resultArr.count == 0 ? NULL : resultArr;
}

+ (BOOL)deleteRecentVideo:(NSString *)videoid{
    return [[[DBManager shareInstance] getDB] executeUpdate:@"UPDATE t_video SET recent = NULL WHERE videoid = ?;", videoid];
}

+ (BOOL)clearRecentRecord{
    return [[[DBManager shareInstance] getDB] executeUpdate:@"UPDATE t_video SET recent = NULL;"];
}

@end
