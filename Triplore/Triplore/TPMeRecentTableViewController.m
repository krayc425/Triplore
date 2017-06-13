//
//  TPMeRecentTableViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/13.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeRecentTableViewController.h"
#import "Utilities.h"
#import "TPVideoManager.h"
#import "TPVideoModel.h"
#import "TPVideoSingleTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString *singleCellIdentifier = @"TPVideoSingleTableViewCell";
static NSString *seriesCellIdentifier = @"TPVideoSeriesTableViewCell";

@interface TPMeRecentTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSArray* videos;

@end

@implementation TPMeRecentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    // cell
    UINib *nib1 = [UINib nibWithNibName:@"TPVideoSingleTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:singleCellIdentifier];
    
    UINib *nib2 = [UINib nibWithNibName:@"TPVideoSeriesTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:seriesCellIdentifier];
    
    UIBarButtonItem *clearBarItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearRecent)];
    self.navigationItem.rightBarButtonItem = clearBarItem;
    
    self.navigationItem.title = @"观看记录";
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadRecentVideos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRecentVideos{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    [[TPVideoManager fetchRecentVideos] enumerateObjectsUsingBlock:^(TPVideo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject:[[TPVideoModel alloc] initWithTPVideo:obj]];
    }];
    self.videos = tempArr;
    [self.tableView reloadData];
}

- (void)clearRecent{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[TPVideoManager clearRecentRecord] ? @"清空成功" : @"清空失败"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        }];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
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
    cell.video = video;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.view.frame);
    return (width / 2 - 10) / 16 * 9 + 20;
}

#pragma mark - DZNEmptyTableViewDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无观看记录";
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [Utilities getColor],
                                 NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:20.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
