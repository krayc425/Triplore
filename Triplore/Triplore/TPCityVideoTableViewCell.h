//
//  TPCityVideoTableViewCell.h
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@class TPVideoModel;

@protocol TPCityVideoTableViewCellDelegate <NSObject>

- (void)didSelectVideo:(TPVideoModel * _Nonnull)video;

@optional

- (void)didTapAllWithMode:(TPCategoryMode)mode;

@end

@interface TPCityVideoTableViewCell : UITableViewCell

@property (nonnull, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonnull, nonatomic) IBOutlet UIButton *allButton;
@property (nonnull, nonatomic) IBOutlet UIButton *allButton2;
@property (nonnull, nonatomic) IBOutlet UIStackView *allButtons;
@property (nonnull, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) TPCategoryMode mode;
@property (nonatomic, nonnull) NSArray<TPVideoModel *> *videos;

@property (nonatomic, nonnull) id<TPCityVideoTableViewCellDelegate> delegate;

@end