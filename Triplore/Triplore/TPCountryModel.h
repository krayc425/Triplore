//
//  TPCountryModel.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPCityModel;

@interface TPCountryModel : NSObject

/**
 国家中文名
 */
@property (copy, nonnull, nonatomic) NSString *chineseName;

/**
 国家英文名
 */
@property (copy, nonnull, nonatomic) NSString *englishName;

/**
 国家图片 URL
 */
@property (copy, nonnull, nonatomic) NSString *imageURL;

/**
 拥有的城市数组
 */
@property (copy, nonatomic) NSArray * _Nonnull cityModelArr;

@end
