//
//  TPVideo.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/1.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 存入数据库的 Video 模型
 */
@interface TPVideo : NSObject

/**
 视频 id
 */
@property (copy, nonatomic, nonnull) NSString *videoid;

/**
 视频信息字典
 */
@property (nonatomic, nonnull) NSDictionary *dict;

/**
 是否收藏
 */
@property (nonatomic) NSInteger favorite;

/**
 最近观看日期
 */
@property (nonatomic, nonnull) NSDate *recent;

- (_Nonnull instancetype)initWithVideoDict:(NSDictionary *_Nonnull)dict;

@end
