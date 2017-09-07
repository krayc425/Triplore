//
//  TPCityTableViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPCityTableViewController.h"
#import "TPCityInfoTableViewCell.h"
#import "TPCityVideoTableViewCell.h"
#import "PYSearchViewController.h"
#import "TPVideoTableViewController.h"
#import "TPPlayViewController.h"
#import "TPVideoModel.h"
#import "TPNetworkHelper.h"
#import "TPCityModel.h"
#import <math.h>

@interface TPCityTableViewController () <PYSearchViewControllerDelegate, TPCityVideoTableViewCellDelegate, TPCityInfoTableViewCellDelegate>

@property (nonatomic, copy) NSArray* videosFood;
@property (nonatomic, copy) NSArray* videosShopping;
@property (nonatomic, copy) NSArray* videosPlace;

@end

@implementation TPCityTableViewController

static NSString *infoCellIdentifier = @"TPCityInfoTableViewCell";
static NSString *videoCellIdentifier = @"TPCityVideoTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearchButton:)];
    
    self.tableView.backgroundColor = TPBackgroundColor;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // cell
    UINib *nib1 = [UINib nibWithNibName:@"TPCityInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:infoCellIdentifier];
    
    UINib *nib2 = [UINib nibWithNibName:@"TPCityVideoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:videoCellIdentifier];
    
    self.navigationItem.title = self.city.chineseName;
    
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)request {
    __weak __typeof__(self) weakSelf = self;
    [TPNetworkHelper fetchVideosByKeywords:@[self.city.chineseName,@"美食"] withSize:10 inPage:1 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        weakSelf.videosFood = [videos subarrayWithRange:NSMakeRange(0, fmin(2, videos.count))];
        [weakSelf.tableView reloadData];
    }];
    
    [TPNetworkHelper fetchVideosByKeywords:@[self.city.chineseName,@"购物"] withSize:10 inPage:1 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        weakSelf.videosShopping = [videos subarrayWithRange:NSMakeRange(0, fmin(2, videos.count))];
        [weakSelf.tableView reloadData];
    }];
    
    [TPNetworkHelper fetchVideosByKeywords:@[self.city.chineseName,@"景点"] withSize:10 inPage:1 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        weakSelf.videosPlace = [videos subarrayWithRange:NSMakeRange(0, fmin(2, videos.count))];
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TPCityInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier forIndexPath:indexPath];
        cell.city = self.city;
        cell.delegate = self;
        return cell;
    } else {
        TPCityVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        switch (indexPath.section) {
            case 1:
                cell.mode = TPCategoryFood;
                cell.videos = self.videosFood;
                break;
            case 2:
                cell.mode = TPCategoryShopping;
                cell.videos = self.videosShopping;
                break;
            case 3:
                cell.mode = TPCategoryPlace;
                cell.videos = self.videosPlace;
                break;
            default:
                break;
        }
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.view.frame);
    if (indexPath.section == 0) {
        return (width / 7 * 3 + width / 15 * 4);
        
    } else {
        return (width - 30) / 2 / 16 * 9 + 55 + 42;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

#pragma mark - TPCityInfoTableViewCellDelegate

- (void)didTapCategory:(TPCategoryMode)mode {
    NSArray *titles = @[@"美食", @"购物", @"景点"];
    
    TPVideoTableViewController *videoViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    videoViewController.site = self.city.chineseName;
    videoViewController.keywords = titles[mode-1];
//    videoViewController.navigationItem.title = titles[mode-1];
    
    [self.navigationController pushViewController:videoViewController animated:YES];
}

#pragma mark - TPCityVideoTableViewCellDelegate

- (void)didTapAllWithMode:(TPCategoryMode)mode {
    
    NSArray *titles = @[@"美食", @"购物", @"景点"];
    
    TPVideoTableViewController *videoViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    videoViewController.site = self.city.chineseName;
    videoViewController.keywords = titles[mode-1];
    
    [self.navigationController pushViewController:videoViewController animated:YES];
}

- (void)didSelectVideo:(TPVideoModel *)video {
    TPPlayViewController *playViewController = [[TPPlayViewController alloc] init];
    [playViewController setNoteMode:TPNewNote];
    playViewController.videoDict = video.videoDict;
    
    [self.navigationController pushViewController:playViewController animated:YES];
}

#pragma mark - Action

- (void)clickSearchButton:(id)sender {
    NSArray *hotSeaches = @[@"美食", @"购物", @"景点"];
    
    PYSearchViewController *searchViewController =
    [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches
                                           searchBarPlaceholder:@"搜索视频"
                                                 didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
                                                     TPVideoTableViewController *resultViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                                     
                                                     resultViewController.site = self.city.chineseName;
                                                     resultViewController.keywords = searchText;
                                                     
                                                     [searchViewController.navigationController pushViewController:resultViewController animated:YES];
                                                     
                                                 }];
    
    searchViewController.title = @"搜索";
    searchViewController.delegate = self;
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:searchViewController animated:NO];
}

#pragma mark - PYSearchViewControllerDelegate

- (void)searchViewControllerWillAppear:(PYSearchViewController *)searchViewController {
    searchViewController.navigationItem.hidesBackButton = YES;
}

- (void)didClickCancel:(PYSearchViewController *)searchViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [searchViewController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
