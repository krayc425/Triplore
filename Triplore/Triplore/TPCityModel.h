//
//  TPCityModel.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPCityModel : NSObject

/**
 城市中文名
 */
@property (copy, nonnull, nonatomic) NSString *chineseName;

/**
 城市英文名
 */
@property (copy, nonatomic, nonnull) NSString *englishName;

/**
 城市图片 URL
 */
@property (copy, nonnull, nonatomic) NSString *imageURL;

@end
