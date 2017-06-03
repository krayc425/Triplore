//
//  TPCityInfoTableViewCell.h
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@protocol TPCityInfoTableViewCellDelegate <NSObject>

@optional

- (void)didTapCategory:(TPCategoryMode)mode;

@end

@interface TPCityInfoTableViewCell : UITableViewCell


@property (nonatomic, nonnull) id<TPCityInfoTableViewCellDelegate> delegate;

@end
