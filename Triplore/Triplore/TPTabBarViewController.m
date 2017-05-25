//
//  TPTabBarViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/22.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPTabBarViewController.h"
#import "ViewController.h"
#import "Utilities.h"
#import "TPSiteTableViewController.h"
#import "TPMeTableViewController.h"

@interface TPTabBarViewController ()

@end

@implementation TPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarController.tabBar.delegate = self;
    self.tabBar.tintColor = [Utilities getColor];
    
    //颜色
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:[Utilities getColor]];
    [bar setTintColor:[Utilities getColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTranslucent:NO];
    UIImage *image = [UIImage imageNamed:@"NAV_BACK"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bar.backIndicatorImage = image;
    bar.backIndicatorTransitionMaskImage = image;

    //精选
    ViewController *vc = [[ViewController alloc] init];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"TAB_HOME"] selectedImage:[UIImage imageNamed:@"TAB_HOME"]];
    vc.tabBarItem = item1;
    UINavigationController *naviVC1 = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //地点
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"地点" image:[UIImage imageNamed:@"TAB_SITE"] selectedImage:[UIImage imageNamed:@"TAB_SITE"]];
    TPSiteTableViewController *tpSiteTableViewController = [[TPSiteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tpSiteTableViewController.tabBarItem = item2;
    UINavigationController *naviVC2 = [[UINavigationController alloc] initWithRootViewController:tpSiteTableViewController];
    
    //书签？
    UIViewController *testVC3 = [[UIViewController alloc] init];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"书签" image:[UIImage imageNamed:@"TAB_BOOK"] selectedImage:[UIImage imageNamed:@"TAB_BOOK"]];
    testVC3.tabBarItem = item3;
    UINavigationController *naviVC3 = [[UINavigationController alloc] initWithRootViewController:testVC3];
    
    //我
    TPMeTableViewController *meVC = [[TPMeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"TAB_PERSON"] selectedImage:[UIImage imageNamed:@"TAB_PERSON"]];
    meVC.tabBarItem = item4;
    UINavigationController *naviVC4 = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    [self addChildViewController:naviVC1];
    [self addChildViewController:naviVC2];
    [self addChildViewController:naviVC3];
    [self addChildViewController:naviVC4];
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

@end
