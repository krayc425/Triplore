//
//  TPVideo.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/1.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideo.h"

@implementation TPVideo

- (instancetype)initWithVideoDict:(NSDictionary *_Nonnull)dict{
    self = [super init];
    if(self){
        self.videoid = [dict[@"id"] integerValue];
        self.dict = dict;
        self.favorite = 0;
        self.recent = [NSDate date];
    }
    return self;
}

@end
