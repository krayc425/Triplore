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
+ (void)fetchAllVideosWithBlock:(void(^)(NSArray<TPVideoModel *> *videos, NSError *error))completionBlock;

/**
 根据关键字找视频

 @param keywords 关键字数组
 @param completionBlock 回调块
 */
+ (void)fetchVideosByKeywords:(NSArray *)keywords withBlock:(void(^)(NSArray<TPVideoModel *> *videos, NSError *error))completionBlock;

@end
