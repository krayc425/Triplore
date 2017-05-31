//
//  TPSiteTableViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSiteTableViewController.h"
#import "TPSiteTableViewCell.h"
#import "Utilities.h"
#import "PYSearchViewController.h"
#import "TPSiteSearchViewController.h"

@interface TPSiteTableViewController () <TPSiteTableViewCellDelegate>

@property (nonatomic, strong) NSArray* testCountries;
@property (nonatomic, strong) NSArray* testCities;

@end

@implementation TPSiteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [Utilities getColor];
    self.navigationController.navigationBar.backgroundColor = [Utilities getColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"地点";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearchButton:)];

    
    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.testCountries = @[@"中国", @"日本", @"泰国", @"英国", @"新加坡"];
    self.testCities = @[@"东京", @"京都", @"大阪"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TPSiteTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"TPSiteTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    TPSiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if (indexPath.section == 0) {
        cell.mode = TPSiteCountry;
        [cell setSites:self.testCountries];
    } else if (indexPath.section == 1) {
        cell.mode = TPSiteCity;
        [cell setSites:self.testCities];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = 0;
    if (indexPath.section == 0) {
        row = self.testCountries.count%3 == 0 ? self.testCountries.count/3 : self.testCountries.count/3 + 1;
    }else if (indexPath.section == 1) {
        row = self.testCities.count%3 == 0 ? self.testCities.count/3 : self.testCities.count/3 + 1;
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

- (void)didSelectSite:(NSString *)site withMode:(TPSiteMode)mode {
    if (mode == TPSiteCountry) {
        TPSiteSearchViewController *countryViewController = [[TPSiteSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
        countryViewController.mode = TPSiteSearchCountry;
        countryViewController.cities = self.testCities;
        countryViewController.navigationItem.title = site;
        [self.navigationController pushViewController:countryViewController animated:YES];
    }
}

- (void)didTapAllWithMode:(TPSiteMode)mode {
    if (mode == TPSiteCountry) {
        TPSiteSearchViewController *countryViewController = [[TPSiteSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
        countryViewController.mode = TPSiteSearchCountry;
        countryViewController.cities = self.testCountries;
        [self.navigationController pushViewController:countryViewController animated:YES];
    } else if (mode == TPSiteSearchCity) {
        TPSiteSearchViewController *cityViewController = [[TPSiteSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
        cityViewController.mode = TPSiteSearchCity;
        cityViewController.cities = self.testCities;
        [self.navigationController pushViewController:cityViewController animated:YES];
    }
}

#pragma mark - Action

- (void)clickSearchButton:(id)sender {
//    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];

    PYSearchViewController *searchViewController =
    [PYSearchViewController searchViewControllerWithHotSearches:self.testCountries
                                           searchBarPlaceholder:@"搜索目的地"
                                                 didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
                                                     TPSiteSearchViewController *resultViewController = [[TPSiteSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                                     resultViewController.mode = TPSiteSearchAll;
                                                     [searchViewController.navigationController pushViewController:resultViewController animated:YES];
        
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    navController.navigationBar.barTintColor = [Utilities getColor];
    navController.navigationBar.backgroundColor = [Utilities getColor];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.navigationBar.tintColor = [UIColor whiteColor];
    
    searchViewController.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    searchViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:navController animated:YES completion:nil];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
