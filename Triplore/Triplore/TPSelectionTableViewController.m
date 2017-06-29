//
//  TPSelectionTableViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/14.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSelectionTableViewController.h"
#import "TPSelectionSliderTableViewCell.h"
#import "TPCityVideoTableViewCell.h"
#import "TPVideoTableViewController.h"
#import "TPPlayViewController.h"
#import "PYSearchViewController.h"
#import "TPNetworkHelper.h"
#import "TPVideoModel.h"
#import "TPRefreshHeader.h"

@interface TPSelectionTableViewController () <PYSearchViewControllerDelegate,TPSelectionSliderTableViewCellDelegate, TPCityVideoTableViewCellDelegate>{
    BOOL doneFood;
    BOOL doneShop;
    BOOL doneView;
}

@property (nonatomic, copy) NSArray* videosFood;
@property (nonatomic, copy) NSArray* videosShopping;
@property (nonatomic, copy) NSArray* videosPlace;
@property (nonatomic, copy) NSArray* videosHot;

@end

@implementation TPSelectionTableViewController

static NSString *cellIdentifier = @"TPSelectionSliderTableViewCell";
static NSString *videoCellIdentifier = @"TPCityVideoTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = TPColor;
    self.navigationController.navigationBar.backgroundColor = TPColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"精选";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearchButton:)];

    self.tableView.backgroundColor = TPBackgroundColor;
    self.tableView.separatorColor = [UIColor clearColor];
    
    UINib *nib1 = [UINib nibWithNibName:@"TPSelectionSliderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:cellIdentifier];
    
    UINib *nib2 = [UINib nibWithNibName:@"TPCityVideoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:videoCellIdentifier];
    
    [self startRequest];
    
    // header
    TPRefreshHeader *header = [TPRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(startRequest)];
    self.tableView.mj_header = header;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)startRequest{
    [self clearBools];
    self.videosHot = [[NSArray alloc] init];
    [self request];
}

- (void)request {
    [TPNetworkHelper fetchVideosByKeywords:@[@"美食", @"旅游"] withSize:10 inPage:1 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        NSLog(@"美食 %lu", (unsigned long)videos.count);
        if (videos.count > 1) {
            NSMutableSet *randomSet = [[NSMutableSet alloc] init];
            while ([randomSet count] < 2) {
                int r = arc4random() % [videos count];
                [randomSet addObject:videos[r]];
            }
            self.videosFood = [randomSet allObjects];
            self.videosHot = [self.videosHot arrayByAddingObjectsFromArray:self.videosFood];
        }
        doneFood = YES;
        if([self checkBools]){
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }];
    [TPNetworkHelper fetchVideosByKeywords:@[@"购物", @"旅游"] withSize:10 inPage:1 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        NSLog(@"购物 %lu", (unsigned long)videos.count);
        if (videos.count > 1) {
            NSMutableSet *randomSet = [[NSMutableSet alloc] init];
            while ([randomSet count] < 2) {
                int r = arc4random() % [videos count];
                [randomSet addObject:videos[r]];
            }
            self.videosShopping = [randomSet allObjects];
            self.videosHot = [self.videosHot arrayByAddingObjectsFromArray:self.videosShopping];
        }
        doneShop = YES;
        if([self checkBools]){
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }];
    [TPNetworkHelper fetchVideosByKeywords:@[@"景点", @"旅游"] withSize:10 inPage:1 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        NSLog(@"景点 %lu", (unsigned long)videos.count);
        if (videos.count > 1) {
            NSMutableSet *randomSet = [[NSMutableSet alloc] init];
            while ([randomSet count] < 2) {
                int r = arc4random() % [videos count];
                [randomSet addObject:videos[r]];
            }
            self.videosPlace = [randomSet allObjects];
            self.videosHot = [self.videosHot arrayByAddingObjectsFromArray:self.videosPlace];
        }
        doneView = YES;
        if([self checkBools]){
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        TPSelectionSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.videos = self.videosHot;
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
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark - TPSelectionSliderTableViewCellDelegate

- (void)didTapCategory:(TPCategoryMode)mode {
    NSArray *titles = @[@"美食", @"购物", @"景点"];
    
    TPVideoTableViewController *videoViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    videoViewController.keywords = titles[mode-1] ;
    
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

- (void)didTapVideo:(TPVideoModel *)video{
    [self didSelectVideo:video];
}

#pragma mark - TPCityVideoTableViewCellDelegate

- (void)didTapAllWithMode:(TPCategoryMode)mode {
    
    NSArray *titles = @[@"美食", @"购物", @"景点"];
    
    TPVideoTableViewController *videoViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
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

#pragma MARK - Bools

- (void)clearBools{
    doneFood = NO;
    doneShop = NO;
    doneView = NO;
}

- (BOOL)checkBools{
    return doneFood && doneView && doneShop;
}

@end
