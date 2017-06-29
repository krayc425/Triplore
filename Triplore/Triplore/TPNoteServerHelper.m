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

@implementation TPNoteServerHelper

+ (void)uploadNote:(TPNoteServer *_Nonnull)note withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    AVFile *noteContextFile = [AVFile fileWithData:note.views];
    [noteContextFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            AVObject *noteObject = [AVObject objectWithClassName:@"note"];
            [noteObject setObject:note.title forKey:@"title"];
            [noteObject setObject:noteContextFile forKey:@"views"];
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
    NSString *cql = [NSString stringWithFormat:@"select * from note order by updatedAt desc limit ?, ?"];
    NSArray *pVals = @[@(start), @(size)];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pVals callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            // 操作成功
            NSMutableArray *resultNoteArray = [[NSMutableArray alloc] init];
            [result.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [resultNoteArray addObject:[[TPNoteServer alloc] initWithAVObject:(AVObject *)obj]];
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

@end
