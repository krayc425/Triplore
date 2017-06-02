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
#import "Utilities.h"

@interface TPCityTableViewController () <PYSearchViewControllerDelegate>

@end

@implementation TPCityTableViewController

static NSString *infoCellIdentifier = @"TPCityInfoTableViewCell";
static NSString *videoCellIdentifier = @"TPCityVideoTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearchButton:)];
    
    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    // cell
    UINib *nib1 = [UINib nibWithNibName:@"TPCityInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:infoCellIdentifier];
    
    UINib *nib2 = [UINib nibWithNibName:@"TPCityVideoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:videoCellIdentifier];
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
        TPCityInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        TPCityVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellIdentifier forIndexPath:indexPath];
        switch (indexPath.section) {
            case 1:
                cell.categoryLabel.text = @"美食";
                break;
            case 2:
                cell.categoryLabel.text = @"购物";
                break;
            case 3:
                cell.categoryLabel.text = @"景点";
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
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

#pragma mark - Action

- (void)clickSearchButton:(id)sender {
    NSArray *hotSeaches = @[@"美食", @"购物", @"景点"];
    
    PYSearchViewController *searchViewController =
    [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches
                                           searchBarPlaceholder:@"搜索视频"
                                                 didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
                                                     TPVideoTableViewController *resultViewController = [[TPVideoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                                                     resultViewController.mode = TPSiteSearchAll;
                                                    resultViewController.navigationItem.title = searchText;
                                                     [searchViewController.navigationController pushViewController:resultViewController animated:YES];
                                                     
                                                 }];
    
    
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
