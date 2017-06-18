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

@property (weak, nonatomic) IBOutlet UILabel * _Nullable categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable allButton;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable allButton2;
@property (weak, nonatomic) IBOutlet UIStackView * _Nullable allButtons;
@property (weak, nonatomic) IBOutlet UICollectionView * _Nullable collectionView;

@property (nonatomic) TPCategoryMode mode;
@property (nonatomic, copy) NSArray<TPVideoModel *> * _Nonnull videos;

@property (nonatomic, weak, nullable) id<TPCityVideoTableViewCellDelegate> delegate;

@end
