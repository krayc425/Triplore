//
//  TPNoteServerHelper.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteServerHelper.h"
#import "TPNoteServer.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TPNoteManager.h"

@implementation TPNoteServerHelper

+ (void)uploadServerNote:(TPNoteServer *_Nonnull)note withBlock:(void(^_Nonnull)(BOOL succeed, NSString *serverID, NSError *_Nullable error))completionBlock{
    
    AVFile *noteContextFile = [AVFile fileWithData:note.views];
    [noteContextFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            AVObject *noteObject = [AVObject objectWithClassName:@"note"];
            [noteObject setObject:note.title forKey:@"title"];
            [noteObject setObject:noteContextFile.url forKey:@"views"];
            [noteObject setObject:[AVUser currentUser] forKey:@"creator"];
            [noteObject setObject:note.videoDict forKey:@"videoDict"];
            [noteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(completionBlock) {
                    completionBlock(succeeded, noteObject.objectId, error);
                }
            }];
        }
    }];
}

+ (void)updateServerNote:(TPNoteServer *_Nonnull)note withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    AVFile *noteContextFile = [AVFile fileWithData:note.views];
    [noteContextFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            AVObject *noteObject = [AVObject objectWithClassName:@"note" objectId:note.noteServerID];
            [noteObject setObject:note.title forKey:@"title"];
            [noteObject setObject:noteContextFile.url forKey:@"views"];
            [noteObject setObject:[AVUser currentUser] forKey:@"creator"];
            [noteObject setObject:note.videoDict forKey:@"videoDict"];
            [noteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(completionBlock) {
                    completionBlock(succeeded, error);
                }
            }];
        }
    }];
}

+ (void)loadServerNotesStartWith:(NSUInteger)start withSize:(NSUInteger)size withBlock:(void(^_Nonnull)(NSArray<TPNoteServer *> * _Nonnull noteServers, NSError *_Nullable error))completionBlock{
    
    NSString *cql = [NSString stringWithFormat:@"select * from note limit ?, ? order by updatedAt desc"];
    NSArray *pVals = @[@(start), @(size)];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql
                                     pvalues:pVals
                                    callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            // 操作成功
            NSMutableArray *resultNoteArray = [[NSMutableArray alloc] init];
            [result.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AVObject *noteObj = (AVObject *)obj;
                [resultNoteArray addObject:[[TPNoteServer alloc] initWithAVObject:noteObj]];
            }];
            if(completionBlock){
                completionBlock([NSArray arrayWithArray:resultNoteArray], error);
            }
        } else {
            NSLog(@"%@", error);
            if(completionBlock){
                completionBlock([NSArray array], error);
            }
        }
    }];
}

+ (void)loadFavoriteServerNotesWithBlock:(void(^_Nonnull)(NSArray<TPNoteServer *> * noteServers, NSError *_Nullable error))completionBlock{
    
    NSError *error;
    if(![self isUserLoggedIn]){
        if(completionBlock){
            error = [NSError errorWithDomain:NSURLErrorDomain
                                        code:801
                                    userInfo:@{@"code" : @(801),
                                               @"description" : @"未登录"}];
            completionBlock(nil, error);
        }
    }else{
        NSString *cql = [NSString stringWithFormat:@"select include note from favorite where user = ? order by updatedAt desc"];
        NSArray *pVals = @[[AVUser currentUser]];
        [AVQuery doCloudQueryInBackgroundWithCQL:cql
                                         pvalues:pVals
                                        callback:^(AVCloudQueryResult *result, NSError *error) {
                                            if (!error) {
                                                // 操作成功
                                                NSMutableArray *resultNoteArray = [[NSMutableArray alloc] init];
                                                [result.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                    AVObject *avObj = (AVObject *)obj[@"note"];
                                                    [resultNoteArray addObject:[[TPNoteServer alloc] initWithAVObject:avObj]];
                                                }];
                                                if(completionBlock){
                                                    completionBlock([NSArray arrayWithArray:resultNoteArray], error);
                                                }
                                            } else {
                                                NSLog(@"%@", error);
                                                if(completionBlock){
                                                    completionBlock([NSArray array], error);
                                                }
                                            }
                                        }];
    }
}


+ (void)deleteServerNote:(TPNoteServer *_Nonnull)note withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    AVObject *noteObj = [AVObject objectWithClassName:@"note" objectId:note.noteServerID];
    
    NSError *error;
    if(![self isUserLoggedIn] || noteObj == nil){
        if(completionBlock){
            error = [NSError errorWithDomain:NSURLErrorDomain
                                        code:801
                                    userInfo:@{@"code" : @(801),
                                               @"description" : @"未登录"}];
            completionBlock(NO, error);
        }
    }else{
        // 删除所有的收藏
        [AVQuery doCloudQueryInBackgroundWithCQL:@"select * from favorite where note = ?"
                                         pvalues:@[noteObj]
                                        callback:^(AVCloudQueryResult *result, NSError *error) {
                                            [result.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                AVObject *favoriteObj = (AVObject *)obj;
                                                [AVQuery doCloudQueryWithCQL:@"delete from favorite where objectId = ?" pvalues:@[favoriteObj.objectId] error:nil];
                                            }];
                                        }];
        // 删除所有的赞
        [AVQuery doCloudQueryInBackgroundWithCQL:@"select * from comment_on where note = ?"
                                         pvalues:@[noteObj]
                                        callback:^(AVCloudQueryResult *result, NSError *error) {
                                            [result.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                AVObject *commentObj = (AVObject *)obj;
                                                [AVQuery doCloudQueryWithCQL:@"delete from comment_on where objectId = ?" pvalues:@[commentObj.objectId] error:nil];
                                            }];
                                        }];
        // 删除笔记
        [AVQuery doCloudQueryInBackgroundWithCQL:@"delete from note where objectId = ?"
                                         pvalues:@[note.noteServerID]
                                        callback:^(AVCloudQueryResult *result, NSError *error) {
                                            // 如果 error 为空，说明保存成功
                                            if (!error) {
                                                completionBlock(YES, error);
                                            }
                                        }];
    }
}

+ (void)commentServerNote:(TPNoteServer *_Nonnull)note withIsLike:(BOOL)isLike withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    AVObject *noteObject = [AVObject objectWithClassName:@"note" objectId:note.noteServerID];
    NSError *error = nil;
    
    if(![self isUserLoggedIn] || noteObject == nil){
        if(completionBlock){
            error = [NSError errorWithDomain:NSURLErrorDomain
                                        code:801
                                    userInfo:@{@"code" : @(801),
                                               @"description" : @"未登录"}];
            NSLog(@"暂未登陆");
            completionBlock(NO, error);
        }
    }else{
        if(isLike){
            if ([self isLike:noteObject]){
                error = [NSError errorWithDomain:NSURLErrorDomain
                                            code:901
                                        userInfo:@{@"code" : @(901),
                                                   @"description" : @"您已评价过"}];
                NSLog(@"您已评过");
                completionBlock(NO, error);
            }else{
                AVObject *commentObject = [AVObject objectWithClassName:@"comment_on"];
                [commentObject setObject:noteObject forKey:@"note"];
                [commentObject setObject:[AVUser currentUser] forKey:@"user"];
                [commentObject setObject:@(isLike) forKey:@"isLike"];
                [commentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                    // 增加喜欢次数
                    [noteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        // 原子增加查看的次数
                        [noteObject incrementKey:@"like"];
                        // 保存时自动取回云端最新数据
                        noteObject.fetchWhenSave = true;
                        [noteObject saveInBackground];
                        if(completionBlock) {
                            completionBlock(succeeded, error);
                        }
                    }];
                }];
            }
        }else{
            [AVQuery doCloudQueryInBackgroundWithCQL:@"select * from comment_on where note = ? and user = ?"
                                             pvalues:@[noteObject, [AVUser currentUser]]
                                            callback:^(AVCloudQueryResult *result, NSError *error) {
                                                [result.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                    
                                                    AVObject *commentObj = (AVObject *)obj;
                                                    [AVQuery doCloudQueryWithCQL:@"delete from comment_on where objectId = ?"
                                                                         pvalues:@[commentObj.objectId]
                                                                           error:nil];
                                                    [noteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                        // 原子减少查看的次数
                                                        [noteObject incrementKey:@"like" byAmount:@(-1)];
                                                        // 保存时自动取回云端最新数据
                                                        noteObject.fetchWhenSave = true;
                                                        [noteObject saveInBackground];
                                                        if(completionBlock) {
                                                            completionBlock(succeeded, error);
                                                        }
                                                    }];
                                                    
                                                }];
                                            }];
        }
    }
}

+ (void)favoriteServerNote:(TPNoteServer *_Nonnull)note withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    AVObject *noteObject = [AVObject objectWithClassName:@"note" objectId:note.noteServerID];
    NSError *error = nil;
    
    if(![self isUserLoggedIn] || noteObject == nil){
        if(completionBlock){
            error = [NSError errorWithDomain:NSURLErrorDomain
                                        code:801
                                    userInfo:@{@"code" : @(801),
                                               @"description" : @"未登录"}];
            completionBlock(NO, error);
        }
    }else{
        if ([self isFavorite:noteObject]){
            error = [NSError errorWithDomain:NSURLErrorDomain
                                        code:902
                                    userInfo:@{@"code" : @(902),
                                               @"description" : @"您已收藏过"}];
            NSLog(@"您已收藏过");
            completionBlock(NO, error);
        }else{
            AVObject *favoriteObject = [AVObject objectWithClassName:@"favorite"];
            [favoriteObject setObject:noteObject forKey:@"note"];
            [favoriteObject setObject:[AVUser currentUser] forKey:@"user"];
            [favoriteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(completionBlock) {
                    completionBlock(succeeded, error);
                }
            }];
        }
    }
}

+ (void)cancelFavoriteServerNote:(TPNoteServer *_Nonnull)note withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    AVObject *noteObject = [AVObject objectWithClassName:@"note" objectId:note.noteServerID];
    
    NSError *error = nil;
    
    if(![self isUserLoggedIn] || noteObject == nil){
        if(completionBlock){
            error = [NSError errorWithDomain:NSURLErrorDomain
                                        code:801
                                    userInfo:@{@"code" : @(801),
                                               @"description" : @"未登录"}];
            completionBlock(NO, error);
        }
    }else{
        [AVQuery doCloudQueryInBackgroundWithCQL:@"select * from favorite where note = ? and user = ?"
                                         pvalues:@[noteObject, [AVUser currentUser]]
                                        callback:^(AVCloudQueryResult *result, NSError *error) {
                                            [result.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                AVObject *favoriteObj = (AVObject *)obj;
                                                [AVQuery doCloudQueryWithCQL:@"delete from favorite where objectId = ?" pvalues:@[favoriteObj.objectId] error:nil];
                                            }];
                                        }];
    }
}

#pragma mark - Helper Private Methods

+ (BOOL)isLikeServerNote:(NSString *_Nonnull)noteServerID{
    AVObject *noteObj = [AVObject objectWithClassName:@"note" objectId:noteServerID];
    return [self isLike:noteObj];
}

+ (BOOL)isFavoriteServerNote:(NSString *_Nonnull)noteServerID{
    AVObject *noteObj = [AVObject objectWithClassName:@"note" objectId:noteServerID];
    return [self isFavorite:noteObj];
}

+ (BOOL)isLike:(AVObject *)noteObject{
    NSError *error = nil;
    AVCloudQueryResult *queryResult = [AVQuery doCloudQueryWithCQL:[NSString stringWithFormat:@"select * from comment_on where user = ? and note = ?"] pvalues:@[[AVUser currentUser], noteObject] error:&error];
    return queryResult.results.count > 0;
}

+ (BOOL)isFavorite:(AVObject *)noteObject{
    NSError *error = nil;
    AVCloudQueryResult *queryResult = [AVQuery doCloudQueryWithCQL:[NSString stringWithFormat:@"select * from favorite where user = ? and note = ?"] pvalues:@[[AVUser currentUser], noteObject] error:&error];
    return queryResult.results.count > 0;
}

+ (BOOL)isUserLoggedIn{
    return [AVUser currentUser] != nil;
}

@end
