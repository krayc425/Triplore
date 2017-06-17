//
//  TPPersonHelper.h
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPPersonModel;

@interface TPPersonHelper : NSObject

+ (void)fetchAllPeopleWithBlock:(void(^_Nonnull)(NSArray<TPPersonModel *> *_Nonnull people, NSError *_Nullable error))completionBlock;

@end
