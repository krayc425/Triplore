//
//  TPCityModel.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPCityModel.h"

@interface TPCityModel() <NSCopying, NSMutableCopying>

@end

@implementation TPCityModel

- (id)copyWithZone:(NSZone *)zone {
    TPCityModel *newCity = [[TPCityModel alloc] init];
    newCity.chineseName = self.chineseName;
    newCity.englishName = self.englishName;
    newCity.imageURL = self.imageURL;
    return newCity;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    TPCityModel *newCity = [[TPCityModel alloc] init];
    newCity.chineseName = self.chineseName;
    newCity.englishName = self.englishName;
    newCity.imageURL = self.imageURL;
    return newCity;
}

@end
