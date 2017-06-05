//
//  TPSiteHelper.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPCountryModel;

@interface TPSiteHelper : NSObject

+ (void)fetchAllCountriesWithBlock:(void(^_Nonnull)(NSArray<TPCountryModel *> *_Nonnull countries, NSError *_Nullable error))completionBlock;

@end
