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

+ (void)fetchAllVideosWithBlock:(void(^)(NSArray<TPVideoModel *> *videos, NSError *error))completionBlock;

+ (void)fetchVideosByKeywords:(NSArray *)keywords withBlock:(void(^)(NSArray<TPVideoModel *> *videos, NSError *error))completionBlock;

@end
