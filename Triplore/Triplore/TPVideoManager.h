//
//  TPVideoManager.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/1.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPVideo;

@interface TPVideoManager : NSObject

/**
 插入视频

 @param video 视频
 @return 是否插入成功
 */
+ (BOOL)insertVideo:(TPVideo *_Nonnull)video;

/**
 根据 id 得到视频

 @param videoid 视频 id
 @return  视频
 */
+ (TPVideo *_Nullable)fetchVideoWithID:(NSInteger)videoid;

@end
