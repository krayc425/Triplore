//
//  TPNetworkHelper.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPVideoModel;

@interface TPNetworkHelper : NSObject

/**
 获取所有的视频

 @param completionBlock 回调块
 */
+ (void)fetchAllVideosWithBlock:(void(^_Nonnull)(NSArray<TPVideoModel *> *_Nonnull videos, NSError *_Nullable error))completionBlock;

/**
 根据关键字找视频

 @param keywords 关键字数组
 @param completionBlock 回调块
 */
+ (void)fetchVideosByKeywords:(NSArray *_Nonnull)keywords withSize:(NSInteger)size withBlock:(void(^_Nonnull)(NSArray<TPVideoModel *> *_Nonnull videos, NSError *_Nullable error))completionBlock;

/**
 根据专辑名称找视频

 @param albumName 专辑名字
 @param completionBlock 回调块
 */
+ (void)fetchVideosInAlbum:(NSString *_Nonnull)albumName andAlbumID:(NSString *_Nonnull)albumID withBlock:(void(^_Nonnull)(NSArray<TPVideoModel *> *_Nonnull videos, NSError *_Nullable error))completionBlock;

@end
