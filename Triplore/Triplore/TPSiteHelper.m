//
//  TPSiteHelper.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSiteHelper.h"
#import "TPCountryModel.h"
#import "TPCityModel.h"

@implementation TPSiteHelper

+ (void)fetchAllCountriesWithBlock:(void(^_Nonnull)(NSArray<TPCountryModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Site" ofType:@"plist"];
    NSMutableArray *allArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for(NSDictionary *countryDict in allArr){
        TPCountryModel *country = [TPCountryModel new];
        [country setImageURL:countryDict[@"country_image_url"]];
        [country setChineseName:countryDict[@"chinese_name"]];
        [country setEnglishName:countryDict[@"english_name"]];
        NSMutableArray *cityArr = [[NSMutableArray alloc] init];
        for(NSDictionary *cityDict in (NSDictionary *)countryDict[@"city_list"]){
            TPCityModel *city = [TPCityModel new];
            [city setChineseName:cityDict[@"chinese_name"]];
            [city setEnglishName:cityDict[@"english_name"]];
            [city setImageURL:cityDict[@"image_url"]];
            [cityArr addObject:city];
        }
        [country setCityModelArr:[NSArray arrayWithArray:cityArr]];
        [resultArr addObject:country];
    }
    
    if (completionBlock){
        completionBlock([NSArray arrayWithArray:resultArr], nil);
    }
}

@end
