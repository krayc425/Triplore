//
//  TPPersonModel.h
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPPersonModel : NSObject

@property (copy, nonnull, nonatomic) NSString *name;
@property (copy, nonnull, nonatomic) NSString *avatarName;
@property (copy, nonnull, nonatomic) NSString *introduction;

- (_Nonnull instancetype)initWithDict:(NSDictionary *_Nonnull)dict;

@end
