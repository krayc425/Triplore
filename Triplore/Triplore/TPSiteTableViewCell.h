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

@protocol TPSiteTableViewCellDelegate <NSObject>

- (void)didSelectSite:(NSString * _Nonnull)site withMode:(TPSiteMode)mode;

@optional

- (void)didTapAllWithMode:(TPSiteMode)mode;

@end

@interface TPSiteTableViewCell : UITableViewCell

@property (nonnull, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonnull, nonatomic) IBOutlet UIStackView *allButtons;
@property (nonnull, nonatomic) IBOutlet UIButton *allButton;
@property (nonnull, nonatomic) IBOutlet UIButton *allButton2;
@property (nonnull, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) BOOL isAll;

@property (nonatomic) TPSiteMode mode;
@property (nonatomic, nonnull) NSArray *sites;

@property (nonatomic, nonnull) id<TPSiteTableViewCellDelegate> delegate;

@end
