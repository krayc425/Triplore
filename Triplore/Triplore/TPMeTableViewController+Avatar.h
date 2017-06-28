//
//  TPMeTableViewController+Avatar.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeTableViewController.h"

@interface TPMeTableViewController (Avatar) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)updateAvatar;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;

@end
