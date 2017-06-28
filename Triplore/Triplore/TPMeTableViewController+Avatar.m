//
//  TPMeTableViewController+Avatar.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeTableViewController+Avatar.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "UIImage+Extend.h"

@implementation TPMeTableViewController (Avatar)

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
    // 缩小尺寸
    avatar = [avatar changeImageSizeWithOriginalImage:avatar percent:0.25];
    if (avatar) {
        NSData *imgData = UIImagePNGRepresentation(avatar);
        AVFile *avatarFile = [AVFile fileWithData:imgData];
        [avatarFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"File URL: %@", avatarFile.url);
                // 更新当前用户头像 URL
                [[AVUser currentUser] setObject:avatarFile forKey:@"avatar"];
                [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [self loadUser];
                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"上传失败\n%@", [error localizedDescription]]];
                    }
                    [SVProgressHUD dismissWithDelay:1];
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                [SVProgressHUD dismissWithDelay:1];
            }
        } progressBlock:^(NSInteger percentDone) {
            [SVProgressHUD showProgress:percentDone / 100.0 status:@"上传中"];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
