//
//  TPPersonHelper.m
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPPersonHelper.h"
#import "TPPersonModel.h"

@implementation TPPersonHelper

+ (void)fetchAllPeopleWithBlock:(void (^)(NSArray<TPPersonModel *> * _Nonnull people, NSError * _Nullable error))completionBlock {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"About" ofType:@"plist"];
    NSMutableArray *rootArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    
    for(NSDictionary *personDic in rootArr){
        TPPersonModel *person = [[TPPersonModel alloc] initWithDict:personDic];
        [resultArr addObject:person];
    }
    
    if (completionBlock){
        completionBlock([NSArray arrayWithArray:resultArr], nil);
    }
}

@end
