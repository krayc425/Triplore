//
//  TPSelectionSliderTableViewCell.h
//  Triplore
//
//  Created by Sorumi on 17/6/14.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@class TPVideoModel;

@protocol TPSelectionSliderTableViewCellDelegate <NSObject>

@optional

- (void)didTapCategory:(TPCategoryMode)mode;

@end

@interface TPSelectionSliderTableViewCell : UITableViewCell

@property (nonatomic, nonnull) id<TPSelectionSliderTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSArray<TPVideoModel *>* _Nonnull videos;

@end
