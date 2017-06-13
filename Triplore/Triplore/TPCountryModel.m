//
//  TPCountryModel.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPCountryModel.h"

@interface TPCountryModel() <NSCopying, NSMutableCopying>

@end

@implementation TPCountryModel

- (id)copyWithZone:(NSZone *)zone {
    TPCountryModel *newCountry = [[TPCountryModel alloc] init];
    newCountry.chineseName = self.chineseName;
    newCountry.englishName = self.englishName;
    newCountry.imageURL = self.imageURL;
    newCountry.cityModelArr = self.cityModelArr;
    return newCountry;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    TPCountryModel *newCountry = [[TPCountryModel alloc] init];
    newCountry.chineseName = self.chineseName;
    newCountry.englishName = self.englishName;
    newCountry.imageURL = self.imageURL;
    newCountry.cityModelArr = self.cityModelArr;
    return newCountry;
}

@end
