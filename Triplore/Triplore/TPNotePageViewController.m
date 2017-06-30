//
//  TPNotePageViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/29.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNotePageViewController.h"
#import "TPNoteCollectionViewController.h"
#import "TPNoteServerCollectionViewController.h"
#import "TPNoteFavoriteCollectionViewController.h"
#import "CAPSPageMenu.h"

@interface TPNotePageViewController ()

@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation TPNotePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
       
    self.navigationController.navigationBar.barTintColor = TPColor;
    self.navigationController.navigationBar.backgroundColor = TPColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"笔记";
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    TPNoteServerCollectionViewController *controller1 = [[TPNoteServerCollectionViewController alloc] initWithCollectionViewLayout:layout1];
    controller1.title = @"推荐";
    
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    TPNoteCollectionViewController *controller2 = [[TPNoteCollectionViewController alloc] initWithCollectionViewLayout:layout2];
    controller2.title = @"我的";
    
    UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc] init];
    TPNoteFavoriteCollectionViewController *controller3 = [[TPNoteFavoriteCollectionViewController alloc] initWithCollectionViewLayout:layout3];
    controller3.title = @"收藏";
    
    NSArray *controllerArray = @[controller1, controller2, controller3];
    
    for (TPNoteCollectionViewController *controller in controllerArray) {
        controller.parentNavigationController = self.navigationController;
    }
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: TPColor,
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: TPColor,
                                 CAPSPageMenuOptionAddBottomMenuHairline: @(NO),
                                 CAPSPageMenuOptionMenuItemWidth: @(54),
                                 CAPSPageMenuOptionMenuHeight: @(40),
                                 CAPSPageMenuOptionMenuMargin: @(20),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
//                                 CAPSPageMenuOptionMenuItemWidthBasedOnTitleTextWidth: @(YES),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionMenuItemFont: [UIFont systemFontOfSize:14.0f],
                                 CAPSPageMenuOptionSelectionIndicatorHeight: @(2)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-44) options:parameters];
    [self.view addSubview:_pageMenu.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
