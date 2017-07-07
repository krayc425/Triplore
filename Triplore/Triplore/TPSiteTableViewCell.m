//
//  TPSiteTableViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSiteTableViewCell.h"
#import "TPSiteCollectionViewCell.h"
#import "TPCountryModel.h"
#import "TPCityModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TPSiteTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation TPSiteTableViewCell

static NSString * const reuseIdentifier = @"TPSiteCollectionViewCell";


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.categoryLabel sizeToFit];
    

    [self.allButton setTitleColor:TPColor forState:UIControlStateNormal];
    [self.allButton2 setTitleColor:TPColor forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"TPSiteCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsAll:(BOOL)isAll {
    _isAll = isAll;
    self.allButtons.hidden = !isAll;
}

- (void)setMode:(TPSiteMode)mode {
    _mode = mode;
    if (mode == TPSiteCountry) {
        self.categoryLabel.text = @"国家";
    } else if (mode == TPSiteCity) {
        self.categoryLabel.text = @"城市";
    }
}

- (void)setCountries:(NSArray<TPCountryModel *> *)countries {
    _countries = countries;
    [self.collectionView reloadData];
}

- (void)setCities:(NSArray<TPCityModel *> *)cities {
    _cities = cities;
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.mode == TPSiteCountry) {
        return self.countries.count;
    } else if (self.mode == TPSiteCity) {
        return self.cities.count;
    }
    return 0;
}

- (TPSiteCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPSiteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.mode == TPSiteCountry) {
        cell.titleLabel.text = self.countries[indexPath.item].chineseName;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.countries[indexPath.item].imageURL]];
        
    } else if (self.mode == TPSiteCity) {
        cell.titleLabel.text = self.cities[indexPath.item].chineseName;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.cities[indexPath.item].imageURL]];
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mode == TPSiteCountry && [self.delegate respondsToSelector:@selector(didSelectCountry:)]) {
        NSLog(@"select %@", self.countries[indexPath.item]);
        [self.delegate didSelectCountry:self.countries[indexPath.item]];
    } else if (self.mode == TPSiteCity && [self.delegate respondsToSelector:@selector(didSelectCity:)]) {
        NSLog(@"select %@", self.cities[indexPath.item]);
        [self.delegate didSelectCity:self.cities[indexPath.item]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%f %f", (CGRectGetWidth(self.collectionView.frame) - 20) / 3 - 5, (CGRectGetWidth(self.collectionView.frame) - 20) / 2);
    return CGSizeMake((CGRectGetWidth(self.collectionView.frame) - 20) / 3 - 5, (CGRectGetWidth(self.collectionView.frame) - 20) / 2);
}

- (IBAction)allDidTap:(id)sender {
    if([self.delegate respondsToSelector:@selector(didTapAllWithMode:)]) {
        [self.delegate didTapAllWithMode:self.mode];
    }
}

@end
