//
//  TPCityVideoTableViewCell.h
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPCityVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton2;
@property (weak, nonatomic) IBOutlet UIStackView *allButtons;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
