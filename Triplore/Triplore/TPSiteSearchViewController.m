//
//  TPSiteSearchViewController.m
//  Triplore
//
//  Created by Sorumi on 17/5/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSiteSearchViewController.h"
#import "TPCityTableViewController.h"
#import "Utilities.h"
#import "TPSiteTableViewCell.h"
#import "TPCountryModel.h"
#import "TPCityModel.h"

@interface TPSiteSearchViewController () <TPSiteTableViewCellDelegate>

@end

@implementation TPSiteSearchViewController

static NSString *cellIdentifier = @"TPSiteTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    UINib *nib = [UINib nibWithNibName:@"TPSiteTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.mode == TPSiteSearchAll) {
        return 2;
    } else if (self.mode == TPSiteSearchCity || self.mode == TPSiteSearchCountry) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    TPSiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.isAll = NO;
    
    if (self.mode == TPSiteSearchAll || self.mode == TPSiteSearchCountry) {
        if (indexPath.section == 0) {
            if (self.countries.count == 0) {
                [cell setHidden:YES];
            } else {
                cell.mode = TPSiteCountry;
                cell.countries = self.countries;
            }
            
        } else if (indexPath.section == 1) {
            if (self.cities.count == 0) {
                [cell setHidden:YES];
            } else {
                cell.mode = TPSiteCity;
                cell.cities = self.cities;
            }
           
        }
    } else if (self.mode == TPSiteSearchCity) {
        cell.mode = TPSiteCity;
        cell.cities = self.cities;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = 0;
    if (self.mode == TPSiteSearchAll || self.mode == TPSiteSearchCountry) {
        if (indexPath.section == 0) {
            row = self.countries.count%3 == 0 ? self.countries.count/3 : self.countries.count/3 + 1;
        }else if (indexPath.section == 1) {
            row = self.cities.count%3 == 0 ? self.cities.count/3 : self.cities.count/3 + 1;
        }
    } else if (self.mode == TPSiteSearchCity) {
        row = self.cities.count%3 == 0 ? self.cities.count/3 : self.cities.count/3 + 1;
    }
    return (CGRectGetWidth(self.view.frame) - 40)/2 * row + 10 * (row-1) + 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

#pragma mark - TPSiteTableViewCellDelegate

- (void)didSelectCountry:(TPCountryModel *)country {
    TPSiteSearchViewController *countryViewController = [[TPSiteSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
    countryViewController.mode = TPSiteSearchCity;
    countryViewController.cities = country.cityModelArr;
    countryViewController.navigationItem.title = country.chineseName;
    [self.navigationController pushViewController:countryViewController animated:YES];
}

- (void)didSelectCity:(TPCityModel *)city {
    TPCityTableViewController *cityViewController = [[TPCityTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    cityViewController.city = city;
    [self.navigationController pushViewController:cityViewController animated:YES];
    
}

@end
