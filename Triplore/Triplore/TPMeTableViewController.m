//
//  TPMeTableViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeTableViewController.h"
#import "TPMeTableViewCell.h"
#import "Utilities.h"
#import "TPMeFavoriteTableViewController.h"
#import "TPMeRecentTableViewController.h"

@interface TPMeTableViewController ()

@end

@implementation TPMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [Utilities getColor];
    self.navigationController.navigationBar.backgroundColor = [Utilities getColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"我";
    
    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TPMeTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"TPMeTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    TPMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        [cell.cellImg setImage:[UIImage imageNamed:@"ME_COLLECT"]];
        [cell.infoLabel setText:@"我的收藏"];
        
    }else if(indexPath.section == 0 && indexPath.row == 1){
        [cell.cellImg setImage:[UIImage imageNamed:@"ME_RECORD"]];
        [cell.infoLabel setText:@"观看记录"];
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        [cell.cellImg setImage:[UIImage imageNamed:@"ME_SETTINGS"]];
        [cell.infoLabel setText:@"设置"];
        
    }else if(indexPath.section == 2 && indexPath.row == 0){
        [cell.cellImg setImage:[UIImage imageNamed:@"ME_ABOUT"]];
        [cell.infoLabel setText:@"关于我们"];
        
    }else{
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        TPMeFavoriteTableViewController *favoVC = [[TPMeFavoriteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:favoVC animated:YES];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        TPMeRecentTableViewController *recentVC = [[TPMeRecentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:recentVC animated:YES];
    }else if(indexPath.section == 1 && indexPath.row == 0){
        
    }else if(indexPath.section == 2 && indexPath.row == 0){
        
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.0001)];
}

@end
