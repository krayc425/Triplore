//
//  TPSiteHelper.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPCountryModel;
@class TPCityModel;

@interface TPSiteHelper : NSObject

+ (void)fetchAllCountriesWithBlock:(void(^_Nonnull)(NSArray<TPCountryModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock;
+ (void)fetchCountriesWithNum:(NSInteger)num withBlock:(void(^_Nonnull)(NSArray<TPCountryModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock;

+ (void)fetchHotCountriesWithBlock:(void(^_Nonnull)(NSArray<TPCountryModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock;
+ (void)fetchHotCitiesWithBlock:(void(^_Nonnull)(NSArray<TPCityModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock;


+ (void)searchCountriesWithName:(NSString *_Nonnull)name withBlock:(void (^_Nonnull)(NSArray<TPCountryModel *> * _Nonnull, NSError * _Nullable))completionBlock;
+ (void)searchCitiesWithName:(NSString *_Nonnull)name withBlock:(void (^_Nonnull)(NSArray<TPCityModel *> * _Nonnull, NSError * _Nullable))completionBlock;
@end
