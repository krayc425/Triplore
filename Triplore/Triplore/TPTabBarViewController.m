//
//  TPTabBarViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/22.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPTabBarViewController.h"
#import "TPSelectionViewController.h"
#import "Utilities.h"
#import "TPSiteTableViewController.h"
#import "TPNoteCollectionViewController.h"
#import "TPMeTableViewController.h"

@interface TPTabBarViewController ()

@end

@implementation TPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TabBar
    self.tabBarController.tabBar.delegate = self;
    self.tabBar.tintColor = [Utilities getColor];
    
    //NavigationBar
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBarTintColor:[Utilities getColor]];
//    [bar setTintColor:[Utilities getColor]];
//    [bar setTitleTextAttributes:@{
//                                  NSForegroundColorAttributeName : [UIColor whiteColor],
//                                  NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f]
//                                  }];
    //    [bar setTranslucent:NO];
    
//    UINavigationBar *bar = [UINavigationBar appearance];
//    UIImage *image = [UIImage imageNamed:@"NAV_BACK"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    bar.backIndicatorImage = image;
//    bar.backIndicatorTransitionMaskImage = image;
    
    //精选
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"TAB_HOME"] selectedImage:[UIImage imageNamed:@"TAB_HOME"]];
    TPSelectionViewController *vc = [[TPSelectionViewController alloc] init];
    vc.tabBarItem = item1;
    UINavigationController *naviVC1 = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //地点
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"地点" image:[UIImage imageNamed:@"TAB_SITE"] selectedImage:[UIImage imageNamed:@"TAB_SITE"]];
    TPSiteTableViewController *tpSiteTableViewController = [[TPSiteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tpSiteTableViewController.tabBarItem = item2;
    UINavigationController *naviVC2 = [[UINavigationController alloc] initWithRootViewController:tpSiteTableViewController];
    
    //笔记
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    TPNoteCollectionViewController *noteVC = [[TPNoteCollectionViewController alloc] initWithCollectionViewLayout:layout];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"笔记" image:[UIImage imageNamed:@"TAB_BOOK"] selectedImage:[UIImage imageNamed:@"TAB_BOOK"]];
    noteVC.tabBarItem = item3;
    UINavigationController *naviVC3 = [[UINavigationController alloc] initWithRootViewController:noteVC];
    
    //我
    TPMeTableViewController *meVC = [[TPMeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"TAB_PERSON"] selectedImage:[UIImage imageNamed:@"TAB_PERSON"]];
    meVC.tabBarItem = item4;
    UINavigationController *naviVC4 = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    [self addChildViewController:naviVC1];
    [self addChildViewController:naviVC2];
    [self addChildViewController:naviVC3];
    [self addChildViewController:naviVC4];
    
    for(UINavigationController *naviVC in self.childViewControllers) {
        naviVC.navigationBar.translucent = NO;
        naviVC.navigationBar.opaque = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    //显式调用子 vc 的 viewwillappear
    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    //显式调用子 vc 的 viewdidappear
    [self.selectedViewController viewDidAppear:animated];
}

#pragma mark - BarButton Pressed

- (void)backBarButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (self.selectedIndex) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
