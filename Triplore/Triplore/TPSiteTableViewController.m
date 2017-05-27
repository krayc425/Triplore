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

@interface TPSiteTableViewController ()

@property (nonatomic, strong) NSArray* testCountries;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.testCountries = @[@"中国", @"日本", @"泰国", @"英国", @"新加坡"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TPSiteTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"TPSiteTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    TPSiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setSites:self.testCountries];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = self.testCountries.count%3 == 0 ? self.testCountries.count/3 : self.testCountries.count/3 + 1;
    return (CGRectGetWidth(self.view.frame) - 40)/2 * row + 10 * (row-1) + 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   
    return 0.1;
}


- (void)clickSearchButton:(id)sender {
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"Search programming language" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
        
    }];
    // 3. present the searchViewController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    navController.navigationBar.barTintColor = [Utilities getColor];
    navController.navigationBar.backgroundColor = [Utilities getColor];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.navigationBar.tintColor = [UIColor whiteColor];
    
    searchViewController.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    searchViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:navController  animated:YES completion:nil];

    
//    CourseSearchTableViewController *controller = [[CourseSearchTableViewController alloc] init];
//    //    controller.courseList = _courseList;
//    
//    UINavigationController *navgationController = [[UINavigationController alloc] initWithRootViewController:controller];
//    
//    controller.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
//    controller.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:navgationController animated:YES completion:nil];
    
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
