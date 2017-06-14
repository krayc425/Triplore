//
//  TPVideoTableViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideoTableViewController.h"
#import "TPVideoSingleTableViewCell.h"
#import "TPVideoSeriesTableViewCell.h"
#import "TPPlayViewController.h"
#import "TPVideoModel.h"
#import "TPNetworkHelper.h"
#import "Utilities.h"

@interface TPVideoTableViewController ()

@property (nonatomic, strong) NSArray* videos;

@end

@implementation TPVideoTableViewController

static NSString *singleCellIdentifier = @"TPVideoSingleTableViewCell";
static NSString *seriesCellIdentifier = @"TPVideoSeriesTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    // cell
    UINib *nib1 = [UINib nibWithNibName:@"TPVideoSingleTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:singleCellIdentifier];

    UINib *nib2 = [UINib nibWithNibName:@"TPVideoSeriesTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:seriesCellIdentifier];

    //
    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.title = self.keywords;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self request];
}

#pragma mark - Request

- (void)request {
    NSArray *keywords;
    
    if (self.site == NULL) {
        keywords = [self.keywords componentsSeparatedByString: @" "];
    } else {
        keywords = [[self.keywords componentsSeparatedByString: @" "] arrayByAddingObject:self.site];
    }
    
    [TPNetworkHelper fetchVideosByKeywords:keywords withSize:10 withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
        self.videos = videos;
        [self.tableView reloadData];
    }];
    
    

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
    
    if (video.videoType == TPVideoAlbum) {
        TPVideoSeriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:seriesCellIdentifier forIndexPath:indexPath];
        cell.video = video;
            [TPNetworkHelper fetchVideosInAlbum:@"美食大冒险之文明之旅" andAlbumID:@"205526001" withBlock:^(NSArray<TPVideoModel *> *videos, NSError *error) {
                
                NSLog(@"美食大冒险之文明之");
                NSLog(@"%d", videos.count);
                
            }];
        
        [TPNetworkHelper fetchVideosInAlbum:@"" andAlbumID:[NSString stringWithFormat:@"%d", video.videoid] withBlock:^(NSArray<TPVideoModel *> * _Nonnull videos, NSError * _Nullable error) {
            
            NSLog(@"%@ %d", video.title, video.videoid);
            NSLog(@"%d", videos.count);
            
        }];
//        cell.count = 6;
        
        return cell;
    } else {
        TPVideoSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singleCellIdentifier forIndexPath:indexPath];
        cell.video = video;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.view.frame);
    TPVideoModel *video = self.videos[indexPath.section];
    
    if (video.videoType == TPVideoAlbum) {
        return (width / 2 - 10) / 16 * 9 + 20 + 47 + 3*30 + 2*10;
    } else {
        return (width / 2 - 10) / 16 * 9 + 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TPVideoModel *video = self.videos[indexPath.section];
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
