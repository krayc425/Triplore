//
//  TPPersonModel.m
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPPersonModel.h"

@implementation TPPersonModel

- (instancetype)initWithDict:(NSDictionary *_Nonnull)dict{
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.avatarName = dict[@"avatar"];
        self.introduction = dict[@"introduction"];
    }
    return self;
}

@end
