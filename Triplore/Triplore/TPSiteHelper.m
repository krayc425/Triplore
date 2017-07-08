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

+ (void)fetchCountriesWithNum:(NSInteger)num withBlock:(void(^_Nonnull)(NSArray<TPCountryModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Site" ofType:@"plist"];
    NSArray *allArr = [[[NSMutableArray alloc] initWithContentsOfFile:filePath] subarrayWithRange:NSMakeRange(0, num)];
    
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


+ (void)fetchHotCountriesWithBlock:(void(^_Nonnull)(NSArray<TPCountryModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Site" ofType:@"plist"];
    NSMutableArray *allArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *randomArray = [[NSMutableArray alloc] init];
    
    while ([randomArray count] < 6) {
        int r = arc4random() % [allArr count];
        if(![randomArray containsObject:[allArr objectAtIndex:r]]){
            [randomArray addObject:[allArr objectAtIndex:r]];
        }else{
            continue;
        }
    }

    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for(NSDictionary *countryDict in randomArray){
        
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


+ (void)fetchHotCitiesWithBlock:(void(^_Nonnull)(NSArray<TPCityModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Site" ofType:@"plist"];
    NSMutableArray *allArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *randomConuntryArray = [[NSMutableArray alloc] init];
    
    while ([randomConuntryArray count] < 6) {
        int r = arc4random() % [allArr count];
        if(![randomConuntryArray containsObject:[allArr objectAtIndex:r]]){
            [randomConuntryArray addObject:[allArr objectAtIndex:r]];
        }else{
            continue;
        }
    }

    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    
    for(NSDictionary *countryDict in randomConuntryArray){
        NSArray *cityArr = countryDict[@"city_list"];
        int r = arc4random() % [cityArr count];
        NSDictionary *cityDict = cityArr[r];
        TPCityModel *city = [TPCityModel new];
        [city setChineseName:cityDict[@"chinese_name"]];
        [city setEnglishName:cityDict[@"english_name"]];
        [city setImageURL:cityDict[@"image_url"]];
        if(![resultArr containsObject:city]) {
            [resultArr addObject:city];
        }else{
            continue;
        }
    }
    
    if (completionBlock){
        completionBlock([NSArray arrayWithArray:resultArr], nil);
    }
}


+ (void)searchCountriesWithName:(NSString *)name withBlock:(void (^)(NSArray<TPCountryModel *> * _Nonnull, NSError * _Nullable))completionBlock {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Site" ofType:@"plist"];
    NSMutableArray *allArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for(NSDictionary *countryDict in allArr){
        
        NSString *chineseName = countryDict[@"chinese_name"];
        
        if ([chineseName rangeOfString:name].location != NSNotFound) {
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
    }
    
    if (completionBlock){
        completionBlock([NSArray arrayWithArray:resultArr], nil);
    }

}

+ (void)searchCitiesWithName:(NSString *)name withBlock:(void (^)(NSArray<TPCityModel *> * _Nonnull, NSError * _Nullable))completionBlock {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Site" ofType:@"plist"];
    NSMutableArray *allArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    
    for(NSDictionary *countryDict in allArr){
        for(NSDictionary *cityDict in (NSDictionary *)countryDict[@"city_list"]){
            
            NSString *chineseName = cityDict[@"chinese_name"];

            if ([chineseName rangeOfString:name].location != NSNotFound) {
                TPCityModel *city = [TPCityModel new];
                [city setChineseName:cityDict[@"chinese_name"]];
                [city setEnglishName:cityDict[@"english_name"]];
                [city setImageURL:cityDict[@"image_url"]];
                [resultArr addObject:city];
            }
        }

    }
    
    if (completionBlock){
        completionBlock([NSArray arrayWithArray:resultArr], nil);
    }
    
}

@end
