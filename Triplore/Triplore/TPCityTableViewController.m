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
#import "Utilities.h"

@interface TPCityTableViewController ()

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
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 260;
    } else {
        return 180;
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
