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
        return [[[DBManager shareInstance] getDB] executeUpdate:@"INSERT INTO t_video (videoid, dict) VALUES (?, ?)", @(video.videoid), dictData];
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
        return video;
    }
    return NULL;
}

@end
