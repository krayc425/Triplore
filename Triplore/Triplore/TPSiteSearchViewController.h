//
//  TPSiteSearchViewController.h
//  Triplore
//
//  Created by Sorumi on 17/5/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPSiteSearchMode){
    TPSiteSearchCountry     = 1,
    TPSiteSearchCity        = 2,
    TPSiteSearchAll         = 3,
};


@interface TPSiteSearchViewController : UITableViewController

@property (nonatomic) TPSiteSearchMode mode;
@property (nonatomic, strong) NSArray* countries;
@property (nonatomic, strong) NSArray* cities;

@end
