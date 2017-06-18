//
//  TPSiteTableViewCell.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPSiteMode){
    TPSiteCountry   = 1,
    TPSiteCity      = 2,
};

@class TPCountryModel;
@class TPCityModel;

@protocol TPSiteTableViewCellDelegate <NSObject>

- (void)didSelectCountry:(TPCountryModel * _Nonnull)country;
- (void)didSelectCity:(TPCityModel * _Nonnull)city;

@optional

- (void)didTapAllWithMode:(TPSiteMode)mode;

@end

@interface TPSiteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * _Nullable categoryLabel;

@property (weak, nonatomic) IBOutlet UIStackView * _Nullable allButtons;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable allButton;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable allButton2;
@property (weak, nonatomic) IBOutlet UICollectionView * _Nullable collectionView;

@property (nonatomic) BOOL isAll;

@property (nonatomic) TPSiteMode mode;
@property (nonatomic, copy) NSArray<TPCountryModel *>* _Nonnull countries;
@property (nonatomic, copy) NSArray<TPCityModel *>* _Nonnull cities;

@property (nonatomic, weak, nullable) id<TPSiteTableViewCellDelegate> delegate;

@end
