//
//  TPMeFavoriteTableViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/13.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeFavoriteTableViewController.h"

#import "TPVideoManager.h"
#import "TPVideoModel.h"
#import "TPVideoSingleTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString *singleCellIdentifier = @"TPVideoSingleTableViewCell";
static NSString *seriesCellIdentifier = @"TPVideoSeriesTableViewCell";

@interface TPMeFavoriteTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *videos;

@end

@implementation TPMeFavoriteTableViewController

- (void)continueLoading{
    self.videos = [[NSMutableArray alloc] init];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.title = @"我的收藏";
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadFavoriteVideos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFavoriteVideos{
    __weak __typeof__(self) weakSelf = self;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    [[TPVideoManager fetchFavoriteVideos] enumerateObjectsUsingBlock:^(TPVideo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject:[[TPVideoModel alloc] initWithTPVideo:obj]];
    }];
    [weakSelf.videos removeAllObjects];
    [weakSelf.videos addObjectsFromArray:tempArr];
    [weakSelf.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.videos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPVideoModel *video = self.videos[indexPath.section];
    TPVideoSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singleCellIdentifier forIndexPath:indexPath];
    cell.cellDelegate = self;
    [cell setVideo:video];
    [cell setFavorite:[TPVideoManager isFavoriteVideo:((TPVideoModel *)self.videos[indexPath.section]).videoid]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.view.frame);
    return (width / 2 - 10) / 16 * 9 + 20;
}

#pragma mark - DZNEmptyTableViewDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无收藏";
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:TPColor,
                                 NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:20.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
