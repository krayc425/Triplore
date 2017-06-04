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
        return [[[DBManager shareInstance] getDB] executeUpdate:@"INSERT INTO t_video (videoid, dict, favorite) VALUES (?, ?, ?)", @(video.videoid), dictData, @(0)];
    }else{
        return NO;
    }
}

+ (TPVideo *_Nullable)fetchVideoWithID:(NSInteger)videoid{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE videoid = ?;", @(videoid)];
    if([resultSet next]){
        TPVideo *video = [TPVideo new];
        [video setVideoid:videoid];
        NSDictionary *dict = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"dict"]];
        [video setDict:dict];
        [video setFavorite:[resultSet intForColumn:@"favorite"]];
        return video;
    }
    return NULL;
}

+ (BOOL)commentVideo:(TPVideo *_Nonnull)video withFavorite:(NSInteger)isFavorite{
    if([self fetchVideoWithID:video.videoid] == NULL){
        [self insertVideo:video];
    }
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE videoid = ?;", @(video.videoid)];
    if([resultSet next]){
        return [[[DBManager shareInstance] getDB] executeUpdate:@"UPDATE t_video SET favorite = ? WHERE videoid = ?;", @(isFavorite), @(video.videoid)];
    }
    return NO;
}

+ (NSArray<TPVideo *> *_Nullable)fetchFavoriteVideos{
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_video WHERE favorite = ?;", @(1)];
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    if([resultSet next]){
        TPVideo *video = [TPVideo new];
        [video setVideoid:[resultSet intForColumn:@"videoid"]];
        NSDictionary *dict = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"dict"]];
        [video setDict:dict];
        [video setFavorite:[resultSet intForColumn:@"favorite"]];
        [resultArr addObject:video];
    }
    return resultArr.count == 0 ? NULL : resultArr;
}

@end
