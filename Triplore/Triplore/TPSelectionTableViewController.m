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
#import "TPNetworkHelper.h"
#import "TPVideoModel.h"
#import "Utilities.h"

@interface TPSelectionTableViewController () <TPSelectionSliderTableViewCellDelegate, TPCityVideoTableViewCellDelegate>

@property (nonatomic, strong) NSArray* videosFood;
@property (nonatomic, strong) NSArray* videosShopping;
@property (nonatomic, strong) NSArray* videosPlace;

@end

@implementation TPSelectionTableViewController

static NSString *cellIdentifier = @"TPSelectionSliderTableViewCell";
static NSString *videoCellIdentifier = @"TPCityVideoTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [Utilities getColor];
    self.navigationController.navigationBar.backgroundColor = [Utilities getColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"精选";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearchButton:)];

    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    UINib *nib1 = [UINib nibWithNibName:@"TPSelectionSliderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:cellIdentifier];
    
    UINib *nib2 = [UINib nibWithNibName:@"TPCityVideoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:videoCellIdentifier];
    
    
    [self request];
    
    //
//    [TPNetworkHelper fetchAllVideosWithBlock:^(NSArray<TPVideoModel *> * _Nonnull videos, NSError * _Nullable error) {
//        NSLog(@"%d", videos.count);
//        for (TPVideoModel* video in videos) {
//             NSLog(@"%@", video.title);
//        }
//    }];
    
    
}

- (void)request {
    [TPNetworkHelper fetchVideosByKeywords:@[@"旅游", @"美食"] withSize:10 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        self.videosFood = [videos subarrayWithRange:NSMakeRange(0, 2)];
        [self.tableView reloadData];
    }];
    [TPNetworkHelper fetchVideosByKeywords:@[@"旅游", @"购物"] withSize:10 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        self.videosShopping = [videos subarrayWithRange:NSMakeRange(0, 2)];
        [self.tableView reloadData];
    }];
    [TPNetworkHelper fetchVideosByKeywords:@[@"旅游", @"景点"] withSize:10 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        self.videosPlace = [videos subarrayWithRange:NSMakeRange(0, 2)];
        [self.tableView reloadData];
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

- (void)clickSearchButton:(id)sender {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TPSelectionSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

#pragma mark - TPSelectionSliderTableViewCellDelegate

- (void)didTapCategory:(TPCategoryMode)mode {
    NSArray *titles = @[@"美食", @"购物", @"景点"];
    
    TPVideoTableViewController *videoViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    videoViewController.keywords = [titles[mode-1] stringByAppendingString:@" 旅游"];
    
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

#pragma mark - TPCityVideoTableViewCellDelegate

- (void)didTapAllWithMode:(TPCategoryMode)mode {
    
    NSArray *titles = @[@"美食", @"购物", @"景点"];
    
    TPVideoTableViewController *videoViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
        videoViewController.keywords = [titles[mode-1] stringByAppendingString:@" 旅游"];
    
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

- (void)didSelectVideo:(TPVideoModel *)video {
    
    TPPlayViewController *playViewController = [[TPPlayViewController alloc] init];
    [playViewController setNoteMode:TPNewNote];
    playViewController.videoDict = video.videoDict;
    
    [self.navigationController pushViewController:playViewController animated:YES];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
