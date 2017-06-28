//
//  TPMeTableViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeTableViewController.h"
#import "TPMeTableViewCell.h"
#import "TPMeAuthTableViewCell.h"
#import "TPMeLogoutTableViewCell.h"

#import "TPAuthViewController.h"
#import "TPMeFavoriteTableViewController.h"
#import "TPMeRecentTableViewController.h"
#import "TPMeAboutViewController.h"
#import "TPSettingsTableViewController.h"

#import "TPAuthHelper.h"

@interface TPMeTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVUser* user;

@end

@implementation TPMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = TPColor;
    self.navigationController.navigationBar.backgroundColor = TPColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"我";
    
    self.tableView.backgroundColor = TPBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.scrollEnabled = NO;
    
    // user
    
    [TPAuthHelper currentUserWithBlock:^(AVUser * _Nonnull user) {
        if (user) {
            self.user = user;
            [self.tableView reloadData];
        }
    }];
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
    if (self.user) {
        return 5;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 1;
    }else if(section == 3){
        return 1;
    }else if (section == 4){
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellIdentifier = @"TPMeAuthTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"TPMeAuthTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        TPMeAuthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.user = self.user;
        
        return cell;
        
    } else if (indexPath.section == 4 && indexPath.row == 0) {
        static NSString *cellIdentifier = @"TPMeLogoutTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"TPMeLogoutTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        TPMeLogoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

        return cell;
        
    } else {
        static NSString *cellIdentifier = @"TPMeTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"TPMeTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        TPMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if(indexPath.section == 1 && indexPath.row == 0){
            [cell.cellImg setImage:[UIImage imageNamed:@"ME_COLLECT"]];
            [cell.infoLabel setText:@"我的收藏"];
            
        }else if(indexPath.section == 1 && indexPath.row == 1){
            [cell.cellImg setImage:[UIImage imageNamed:@"ME_RECORD"]];
            [cell.infoLabel setText:@"观看记录"];
            
        }else if(indexPath.section == 2 && indexPath.row == 0){
            [cell.cellImg setImage:[UIImage imageNamed:@"ME_SETTINGS"]];
            [cell.infoLabel setText:@"设置"];
            
        }else if(indexPath.section == 3 && indexPath.row == 0){
            [cell.cellImg setImage:[UIImage imageNamed:@"ME_ABOUT"]];
            [cell.infoLabel setText:@"关于我们"];
            
        }else{
            
        }
        
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.user) {
            [self updateAvatar];
        } else {
            TPAuthViewController *authVC = [[TPAuthViewController alloc] init];
            [self.navigationController presentViewController:authVC animated:YES completion:nil];
        }
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        TPMeFavoriteTableViewController *favoVC = [[TPMeFavoriteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:favoVC animated:YES];
    }else if(indexPath.section == 1 && indexPath.row == 1){
        TPMeRecentTableViewController *recentVC = [[TPMeRecentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:recentVC animated:YES];
    }else if(indexPath.section == 2 && indexPath.row == 0){
        TPSettingsTableViewController *settingsVC = [[TPSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:settingsVC animated:YES];
        
    }else if(indexPath.section == 3 && indexPath.row == 0){
        TPMeAboutViewController *aboutVC = [[TPMeAboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if(indexPath.section == 4 && indexPath.row == 0){
#warning todo logout
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 160;
        
    } else {
        return 44;
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

#pragma mark - Action

- (void)updateAvatar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // From albums.
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.allowsEditing = YES;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }]];
    // From camera.
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.allowsEditing = YES;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }]];
    // Cancel.
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *avatar = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (avatar) {
# warning todo
        
//        BOOL success;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSError *error;
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"avatar.jpg"];
//        NSLog(@"imageFile->>%@", imageFilePath);
//        success = [fileManager fileExistsAtPath:imageFilePath];
//        if (success) {
//            success = [fileManager removeItemAtPath:imageFilePath error:&error];
//        }
//        UIImage *smallImage = [self thumbnailWithImageWithoutScale:avatar size:CGSizeMake(1242, 1242)];
//        [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
