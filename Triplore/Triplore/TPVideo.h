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

@property (nonatomic) NSInteger videoid;
@property (nonatomic, nonnull) NSDictionary *dict;
@property (nonatomic) NSInteger favorite;

@end
